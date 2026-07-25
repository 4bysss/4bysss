# Instalación del perfil de GitHub de 4bysss

Este paquete sustituye el README actual por un perfil profesional con:

- Cabecera animada estilo terminal.
- Posicionamiento Java, Spring Boot, Angular, Kotlin/Android y ciberseguridad.
- Proyecto destacado UnderAnime Rebirth.
- Métricas calculadas diariamente mediante la API oficial de GitHub.
- Gráfico de actividad.
- Pac-Man animado sobre el calendario de contribuciones.
- `AGENTS.md` y `llms.txt` para herramientas automáticas y agentes de IA.

No incluye Snake ni Buscaminas.

## Archivos que debes subir

Copia todo el contenido de este paquete en la raíz del repositorio:

```text
4bysss/4bysss
├── README.md
├── AGENTS.md
├── llms.txt
├── scripts/
│   └── gen-pacman.mjs
└── .github/
    └── workflows/
        └── profile-art.yml
```

## Elimina la configuración antigua de Snake

En tu repositorio existen o han existido archivos relacionados con Snake. Elimina los que encuentres:

```text
Snake.yml
.github/workflows/Snake.yml
.github/workflows/snake.yml
```

No borres la carpeta `.github/workflows`; solo los workflows antiguos de Snake.

## Instalación usando Git

Desde PowerShell:

```powershell
# Clona tu repositorio de perfil.
git clone https://github.com/4bysss/4bysss.git
cd 4bysss

# Elimina los workflows antiguos de Snake si existen.
Remove-Item .\Snake.yml -ErrorAction SilentlyContinue
Remove-Item .\.github\workflows\Snake.yml -ErrorAction SilentlyContinue
Remove-Item .\.github\workflows\snake.yml -ErrorAction SilentlyContinue

# Copia dentro del repositorio los archivos de este paquete,
# manteniendo las carpetas .github/workflows y scripts.

# Revisa los cambios y publícalos.
git status
git add .
git commit -m "Revamp GitHub profile with Pac-Man and professional stack"
git push origin main
```

También puedes subir los archivos desde la interfaz web de GitHub, pero asegúrate de respetar exactamente las rutas de las carpetas.

## Permitir que el workflow publique el Pac-Man

En el repositorio `4bysss/4bysss`:

1. Entra en **Settings**.
2. Abre **Actions → General**.
3. Baja hasta **Workflow permissions**.
4. Selecciona **Read and write permissions**.
5. Guarda los cambios.

El workflow declara permisos mínimos de escritura, pero GitHub también debe permitirlos en la configuración del repositorio.

## Ejecutar la primera generación

1. Abre la pestaña **Actions** del repositorio.
2. Selecciona el workflow **profile-art**.
3. Pulsa **Run workflow**.
4. Espera a que termine correctamente.
5. Comprueba que se ha creado la rama `output`.

El Pac-Man y las insignias pueden tardar un poco en aparecer por la caché de imágenes de GitHub. Después se regenerarán automáticamente cada día.

## Ajustes recomendados del perfil

Cambia también la biografía corta de GitHub. La actual no explica tu perfil profesional. Usa esta:

```text
Java & Kotlin Software Engineer | Spring Boot · Angular · Android | Cybersecurity
```

Añade como enlace principal:

```text
https://www.linkedin.com/in/abysss/
```

Y fija como repositorios destacados:

1. `4bysss`
2. `UnderAnimeRebirth-Releases`
3. Un futuro proyecto público Java/Spring Boot que demuestre tu experiencia actual

No fijaría como proyecto principal `NN-Architecture-Profiler` hasta mejorar su código, resultados y README.

## Comprobaciones si algo falla

### Las insignias o el Pac-Man no aparecen

- Verifica que existe la rama `output`.
- Abre el workflow y revisa el paso que haya fallado.
- Confirma que **Workflow permissions** está en escritura.
- Ejecuta manualmente el workflow otra vez.

### El workflow falla durante npm install

Vuelve a ejecutarlo. Si el problema persiste, revisa si el paquete `pacman-contribution-graph` ha publicado una versión incompatible y fija una versión concreta en `profile-art.yml`.

### GitHub muestra el README antiguo

Confirma que el archivo se llama exactamente `README.md`, está en la rama `main` y se encuentra en la raíz del repositorio `4bysss/4bysss`.
