# Bitácora EAP

Registro de atenciones de profesionales, liquidación mensual (bruto, retención, líquido) y reportes para que cada profesional haga su boleta. Funciona en el navegador, sin instalar nada: los datos se guardan en Supabase y la página se publica en GitHub Pages.

Para verla sin conectar nada, abre `index.html` con `#demo` al final de la dirección (los datos son de ejemplo y no se guardan).

## 1. Crear la base de datos (Supabase)

1. Entra a https://supabase.com, crea una cuenta y un proyecto nuevo (plan gratis). Guarda la contraseña de la base de datos.
2. En el proyecto, abre **SQL Editor** → **New query**, pega todo el contenido de `supabase/schema.sql` y presiona **Run**.
3. Abre **Authentication → Users → Add user → Create new user**. Crea una cuenta (correo + contraseña) para cada persona que va a usar la app, marcando **Auto Confirm User**.
4. **Importante:** en **Authentication**, en la sección de inicio de sesión (*Sign In / Providers*), desactiva **Allow new users to sign up**. Así nadie puede crearse una cuenta por su cuenta y solo entran las personas que tú creaste.
5. Abre **Project Settings → API** y copia la **Project URL** y la llave pública (**anon** o **publishable**). Nunca uses la llave `service_role`.
6. Pega esos dos datos en `config.js`.

## 2. Publicar en GitHub

1. En https://github.com crea un repositorio **público** (por ejemplo `bitacora-eap`).
2. Sube los archivos: `index.html`, `config.js`, `LEEME.md` y la carpeta `supabase` (en la página del repositorio: **Add file → Upload files**, y arrastra todo).
3. En **Settings → Pages**, en *Source* elige **Deploy from a branch**, rama **main**, carpeta **/ (root)**, y guarda.
4. En un minuto la app queda en `https://TU-USUARIO.github.io/bitacora-eap/`. Esa dirección sirve desde cualquier computador o teléfono.

El código y la llave pública quedan visibles en un repositorio público, y eso es normal: los datos están protegidos porque sin iniciar sesión Supabase no entrega nada.

## Uso

- **Liquidación:** resumen del mes por profesional. Desde ahí se abre el **Reporte** de cada uno (imprimir o guardar en PDF) y se descargan los CSV (el resumen incluye los datos de transferencia).
- **Atenciones:** registrar y buscar atenciones, con filtros por profesional, empresa, mes, fechas y paciente.
- **Profesionales:** profesión, datos, tarifa (en pesos o UF, con historial por fecha de vigencia) y datos de transferencia.
- **Empresas / Pacientes:** listas que se mantienen a mano.
- **Configuración:** retención, valor de la UF y nombre que sale en los reportes.
