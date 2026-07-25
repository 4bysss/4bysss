name: profile-art

on:
  schedule:
    - cron: "17 3 * * *" # Daily at 03:17 UTC.
  workflow_dispatch:

# The job only needs permission to publish generated files to the output branch.
permissions:
  contents: write

jobs:
  generate:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout profile repository
        uses: actions/checkout@900f2210b1d28bbbd0bd22d17926b9e224e8f231
        with:
          persist-credentials: false

      - name: Prepare output directory
        run: mkdir -p dist

      - name: Compute profile badges from GitHub API
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OWNER: ${{ github.repository_owner }}
        shell: bash
        run: |
          set -euo pipefail

          # $u is a GraphQL variable and must remain inside the single-quoted query.
          response=$(gh api graphql -f u="$OWNER" -f query='query($u:String!){user(login:$u){
            createdAt
            followers{totalCount}
            repositories(privacy:PUBLIC, ownerAffiliations:OWNER){totalCount}
            contributionsCollection{
              contributionCalendar{totalContributions}
            }
          }}')

          value() { echo "$response" | jq -r "$1"; }
          group_number() { echo "$1" | sed -e ':a' -e 's/\B[0-9]\{3\}\>/,&/;ta'; }
          emit_badge() {
            printf '{"schemaVersion":1,"label":"%s","message":"%s","color":"%s","labelColor":"24292f"}\n' \
              "$2" "$3" "$4" > "dist/$1"
          }

          contributions=$(value '.data.user.contributionsCollection.contributionCalendar.totalContributions')
          followers=$(value '.data.user.followers.totalCount')
          repositories=$(value '.data.user.repositories.totalCount')
          created_at=$(value '.data.user.createdAt')
          years=$(( $(date +%Y) - ${created_at:0:4} ))

          emit_badge contrib-endpoint.json   "contributions (last year)" "$(group_number "$contributions")" 2ea043
          emit_badge followers-endpoint.json "followers"                 "$(group_number "$followers")"     1f6feb
          emit_badge repos-endpoint.json     "public repos"              "$(group_number "$repositories")"  7f52ff
          emit_badge years-endpoint.json     "on GitHub"                 "${years}+ yrs"                     fb8500

      - name: Generate Pac-Man contribution graph
        env:
          OWNER: ${{ github.repository_owner }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          npm install --no-save pacman-contribution-graph jsdom
          node scripts/gen-pacman.mjs

      - name: Publish generated assets to output branch
        uses: peaceiris/actions-gh-pages@84c30a85c19949d7eee79c4ff27748b70285e453
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_branch: output
          publish_dir: dist
          keep_files: true
          enable_jekyll: true
