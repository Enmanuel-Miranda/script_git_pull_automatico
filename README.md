# Script Git Pull Automático

## Descripción general
Script desarrollado en **PowerShell** que automatiza la operación `git pull` en **múltiples repositorios Git locales**.  
Al ejecutarse, el script identifica todas las subcarpetas que contienen un repositorio `.git` dentro de un directorio principal y ejecuta el comando `git pull` para sincronizarlos con sus remotos.  

Este proceso es ideal para tareas programadas, garantizando que todos tus proyectos locales estén actualizados sin intervención manual.

---

## Requerimientos del sistema
El proyecto tiene las siguientes dependencias:

* **Sistema Operativo:** Windows 10 o superior  
* **Intérprete:** PowerShell 5.1 o superior  
* **Git:** Debe estar instalado y agregado al PATH  

---

## Estructura del proyecto
La estructura mínima requerida para el funcionamiento del script es la siguiente.  
El script itera sobre las carpetas que contienen un directorio `.git` (repositorios):

D:\Pruebas<br>
│ <br>
├── Scripts<br>
│ ├── git_pull_multi.ps1 <-- Script principal<br>
│ └── git_pull_errores.txt <-- Archivo de log de errores (se crea automáticamente)<br>
│<br>
└── Repositorios\ <-- Directorio base que contiene tus proyectos Git<br>
├── proyecto-web-a\ <-- Repositorio 1<br>
├── servicio-api-b\ <-- Repositorio 2<br>
└── libreria-c\ <-- Repositorio 3<br>

---

##  Configuración del Script
Antes de ejecutar, es **obligatorio** configurar las siguientes tres variables dentro del archivo `git_pull_multi.ps1` para que coincidan con tus rutas locales:

| Variable | Ejemplo de Ruta | Propósito |
|-----------|-----------------|------------|
| `$RutaDirectorioBase` | `"D:\Pruebas\Repositorio"` | Carpeta que contiene todos tus repositorios (el script buscará subcarpetas con `.git` aquí). |
| `$RutaLogErrores` | `"D:\Pruebas\Scripts\git_pull_errores.txt"` | Ruta y nombre del archivo donde se registrarán los errores de sincronización. |
| `$GitExecutable` | `"C:\Program Files\Git\cmd\git.exe"` | Ruta absoluta al ejecutable de Git. Necesario para el Programador de Tareas. |

---

##  Modo de uso

### Ejecución Manual (Consola)
Abre la consola de PowerShell y ejecuta el siguiente comando:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "D:\Pruebas\Scripts\git_pull_multi.ps1"
```
---

##  Ejecución Automática (Programador de Tareas)
1. Abre el **Programador de Tareas** (`taskschd.msc`).  
2. Crea una **nueva tarea**.  
3. En la pestaña **Acciones**, configura los siguientes campos:

| Campo | Valor |
|-------|--------|
| **Programa o script** | `powershell.exe` |
| **Argumentos** | `-ExecutionPolicy Bypass -File "D:\Pruebas\Scripts\git_pull_multi.ps1"` |
| **Iniciar en (opcional)** | `D:\Pruebas\Scripts` |

---

## 📄 Logs y resultados
El script está configurado con manejo de errores.  
En caso de que un `git pull` falle (por problemas de red, repositorio o autenticación), se genera un registro automático.

* **Ubicación del log:** `D:\Pruebas\Scripts\git_pull_errores.txt`  
* **Contenido:** Fecha, hora y descripción de la excepción que causó el fallo.  

Si el archivo está vacío o solo muestra encabezados, significa que todos los repositorios se actualizaron correctamente.

---



