# razorAP

razorAP es una herramienta de Bash y Python empleada para generar puntos de acceso falsos de redes corporativas. 

Para acceder a una red corporativa, el usuario debe de incluir su nombre de usuario y su contraseña del DC. 

Este punto de acceso fraudulento deberá suplantar el nombre de la red corporativa sobre la que se quiere probar. La intención es que un usuario víctima conecte su dispositivo al AP levantado por nuestra tool en vez de al AP verdadero. Si esto sucede, y el usuario incluye su nombre de usuario y contraseña, razorAP recogerá tanto nombre de usuario como el hash de la contraseña (NTLM).

Ejemplo:

![Screenshot](NTLM.png)

## Instalación

Clonar el repositorio de github.

```bash
git clone https://github.com/migguel0/razorAP
```

Conceder permisos de ejecución al script de instalación.

```bash
chmod +x install.sh
```
Ejecutar el script de instalación.

```bash
./install.sh
```


## Uso

Para lanzarla herramienta ejecutar el script de inilización, el cual abrirá dos nuevas terminales
```bash
./init.sh
```
Por un lado se abrirá la terminal de configuración del punto de acceso y por otro lado la terminal de cracking.

#### Configuración del punto de acceso
La terminal de configuración nos ayudará en el proceso de congiguración con los siguientes pasos:
1. Seleccionar interfaz a emplear.
2. Nombre del punto de acceso.
3. Nombre del certificado (será generado automáticamente por la herramienta)
4. CommonName a emplear.
5. Seleccionar banda sobre la que se desplegará (2.4GHz ó 5GHz)
6. Seleccionar canal

Una vez se hayan completados los pasos, se generarán automáticamente los certificados a incluir en el punto de acceso y se levantará automáticamente.

Ya levantado el punto de acceso, solo queda esperar a que algún usuario se conecte. una vez se conecte se mostrará por la terminal un mensaje similar al siguiente:


Es en este momento cuando podemos hacer uso de la terminal de cracking, o en su defecto, si esta ha sido cerrada, ejecutar el script 'cracker.sh'.

#### Cracking
La herramienta implementada por ahora para tratar de crackear la contraseña es asleap.

Los pasos a seguir sobre el script de cracking son los siguientes:
1. Indicar la herramienta a emplear.
2. Indicar ruta absoluta del diccionario con el que se hará fuerza bruta.
3. Indicar, entre los Hashes enumerados por pantalla, el número que identifica el Hash a crackear.

![Screenshot](razorAP.png)


## Notas

Las pruebas con la herramienta se han hecho en máquina virtual con Kali como SO.

Para las pruebas se ha usado la antena WiFi Alfa AWUS036AC.

Para la generación de los certificados se ha hecho uso del script en Python del siguiente repositorio de github: https://github.com/WJDigby/apd_launchpad.git
