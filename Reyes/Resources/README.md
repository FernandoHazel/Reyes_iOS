# Introducción

Bienvenid@ al repositorio de la aplicación Reyes para iOS.

El propósito de este README es ayudarte a entender cómo está construido el proyecto.

**Importante**: Este README se enfoca en computadoras Mac.

## Tabla de Contenido

- [**Para empezar**](#para-empezar)
  - [**Prerrequisitos**](#prerrequisitos)
  - [**Clonar el repositorio**](#clonar-el-repositorio)
  - [**Arquitectura de la app**](#targets)
  - [**Correr la aplicación localmente**](#correr-la-aplicación-localmente)
- [**Pruebas unitarias**](#pruebas-unitarias)
  - [**Introducción a las pruebas unitarias**](#introducción-a-las-pruebas-unitarias)
  - [**¿Dónde están guardadas las pruebas unitarias?**](#dónde-están-guardadas-las-pruebas-unitarias)
  - [**¿Cómo correr las pruebas unitarias?**](#cómo-correr-las-pruebas-unitarias)
  - [**¿Cómo verificar si las pruebas unitarias pasaron exitosamente?**](#cómo-verificar-si-las-pruebas-unitarias-pasaron-exitosamente)
- [**Modelo de Ramificación**](#modelo-de-ramificación)
- [**Proceso de Revisión**](#proceso-de-revisión)
- [**Versiones de la aplicación Bradescard**](#versiones-de-la-aplicación-bradescard)

------------------------

## **Para empezar**

Para levantar localmente el ambiente de desarrollo, primero asegúrate de tener los prerrequisitos y después sigue los pasos de cada sección.

------------------------

### **Prerrequisitos**

Los prerrequisitos son:

- Tener descargado e instalado [**Xcode**](https://apps.apple.com/mx/app/xcode/id497799835?l=en&mt=12).
  
  **Importante**:
  - Asegurate de tener descargada la última versión de XCode
  - Asegúrate de descargar la versión adecuada para tu Mac, ya que existe para chip de Intel y para chip de Apple.

- Tener instalado `git`.
- El proyecto usa swift package manager por lo que no es necesario instalar cocoapods

------------------------
### **Clonar el repositorio**

Para clonar el repositorio:

  1. Asegurate de que el administrador del repositorio te añada como colaborador para poder clonar el proyecto
  2. Abre tu terminal.
  3. Posiciónate en la carpta donde quieres clonar el repositorio.
  4. Corre el comando:

      `$ git clone git clone https://github.com/FernandoHazel/Reyes_iOS.git`
  
  5. Escribe `yes` cuando te avise "Are you sure you want to continue connecting (yes/no)?".
------------------------
### **Arquitectura de la app**

- Entidades:

    - Players
    - News
    - Products
    - Staff
    - Games

- Firebase:

    - Storage (Aquí se almacenan las imagenes)
    - Firestore (Aquí se almacenan los datos)
    - Crashlytics
    - Messaging

------------------------
### **Instalar el proyecto**

Para instalar el proyecto:

1. Abre tu terminal.
2. Posiciónate en el directorio del proyecto `Reyes_iOS`.
3. Cámbiate a la rama `main2`:

    `$ git checkout main2`

4. Abre el proyecto en **Xcode** Las dependencias se deben instalar automáticamente si no es el caso hay que instalar manualmente el sdk de firebase para iOS.
------------------------
### **Modelo de ramificación**

------------------------
------------------------
### **Tamaños de las imagenes**

La aplicación consume una serie de imagenes desde la sección de storage de firebase.
la app tiene un límite que no le permite descargar imagenes mayores a 2048 * 2048 px esto para evitar hacer llamadas de archivos muy pesados que puedan afectar el tiempo de descarga o incluso hacer que se revase el límite de transmisión de datos del plan gratuiri de firebase, además es necesario que todas las imagenes sigan estos lineamientos para que no veamos deformaciones en la interfaz.

Las medidas que deben tener las imagenes de cada entidad son las siguientes:

- Players: 512*512
- Staff: 512*512
- Products: 512*512
- News: 1280*720
- Rewards Onboarding: 512*512
- Upates: 1024*1024 (Es probable que quitemos esta entidad para homologarla con noticias)

------------------------