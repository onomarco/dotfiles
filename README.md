# Dotfiles

Mi configuración personal para macOS. Scripts modulares y extensibles para configurar rápidamente un nuevo sistema.

## Características

- **Script maestro automatizado** - Una sola línea para instalar todo
- **Modular y extensible** - Fácil de personalizar y expandir
- **Configuraciones de macOS** - Ajustes optimizados para desarrollo
- **Gestión de lenguajes** - Python (uv), Go, Bun
- **Herramientas esenciales** - Git, Docker, CLI tools modernos
- **Dotfiles con symlinks** - Versionados y respaldados

## Prerrequisitos

Antes de instalar, necesitas:

1. **macOS 11+** (Big Sur o posterior)
2. **Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```
3. **Permisos de administrador** (contraseña sudo)
4. **Conexión a internet** estable

### Verificar Prerrequisitos

Ejecuta el script de verificación antes de instalar:

```bash
./check-prereqs.sh
```

Este script comprobará:
- ✓ Sistema operativo (macOS)
- ✓ Xcode Command Line Tools
- ✓ Permisos de administrador
- ✓ Conexión a internet
- ✓ Espacio en disco disponible

## Instalación

**IMPORTANTE:** Revisa los scripts antes de ejecutar. Esta configuración es personal y sobrescribirá archivos existentes.

```bash
# 1. Clonar el repositorio
git clone https://github.com/onomarco/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Verificar prerrequisitos (recomendado)
./check-prereqs.sh

# 3. Ejecutar instalación
./install.sh
```

El script maestro ejecutará automáticamente:
1. Instalación de Homebrew y paquetes
2. Configuraciones de macOS
3. Instalación de lenguajes (Python, Go, Bun)
4. Configuración de aplicaciones (Git, VS Code, Sublime)
5. Creación de symlinks para dotfiles

**Tiempo estimado:** 30-45 minutos (depende de la velocidad de internet)

## Estructura

```
dotfiles/
├── install.sh              # Script maestro
├── check-prereqs.sh        # Verificación de prerrequisitos
├── scripts/
│   ├── utils.sh           # Funciones comunes
│   ├── macos.sh           # Configuraciones del sistema
│   ├── brew.sh            # Homebrew + paquetes
│   ├── symlinks.sh        # Symlinks de dotfiles
│   ├── languages/         # Python, Go, Bun
│   └── apps/              # Git, VS Code, Sublime
└── dotfiles/              # Archivos de configuración
    ├── .zshrc
    ├── .aliases
    ├── .gitconfig
    └── ...
```

## Personalización

### Añadir paquetes Homebrew

Edita `scripts/brew.sh` y añade a los arrays:

```bash
BREW_FORMULAE=(
    # ... existentes
    "tu-nuevo-paquete"
)
```

### Añadir extensiones de VS Code

Edita `scripts/apps/vscode.sh`:

```bash
VSCODE_EXTENSIONS=(
    # ... existentes
    "publisher.extension-name"
)
```

### Añadir configuraciones privadas

Crea `~/.private` con tus variables de entorno:

```bash
cp .private.example ~/.private
# Edita ~/.private con tus datos
```

## Herramientas Incluidas

### Homebrew Formulae
- git, gh (GitHub CLI)
- docker, docker-compose
- curl, wget
- jq, tree, htop
- fzf, bat, eza, ripgrep
- tmux

### Lenguajes
- **Python** - vía `uv` (múltiples versiones)
- **Go** - última versión
- **Bun** - runtime JavaScript moderno

### CLI Tools Modernos
- `bat` - cat con syntax highlighting
- `eza` - ls mejorado
- `ripgrep` - búsqueda ultra rápida
- `fzf` - fuzzy finder

## Post-Instalación

Después de ejecutar el script:

1. **Configura .private**
   ```bash
   cp .private.example ~/.private
   nano ~/.private
   ```

2. **Reinicia la terminal** o ejecuta:
   ```bash
   source ~/.zshrc
   ```

3. **Verifica instalaciones**:
   ```bash
   uv --version
   go version
   bun --version
   ```

## Mantenimiento

### Actualizar paquetes Homebrew
```bash
brew update && brew upgrade
```

### Actualizar herramientas de lenguajes
```bash
uv self update
bun upgrade
```

## Notas

- Compatible con macOS (probado en macOS 14+)
- Requiere permisos de administrador para algunas configuraciones
- Los dotfiles existentes se respaldan antes de crear symlinks
- El script es idempotente (puede ejecutarse múltiples veces)

## Referencias

Inspirado en [CoreyMSchafer/dotfiles](https://github.com/CoreyMSchafer/dotfiles)
