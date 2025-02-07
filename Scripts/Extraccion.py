import os
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Obtener la ruta de la carpeta actual y subir una carpeta
parent_directory = os.path.abspath(os.path.join(os.getcwd(), ".."))

# Ruta de descarga personalizada
download_path = os.path.join(parent_directory, "Data")

# Configuración de Chrome para descargas automáticas
chrome_options = webdriver.ChromeOptions()
prefs = {
    "download.default_directory": download_path,  # Carpeta de descarga
    "download.prompt_for_download": False,  # No pedir confirmación
    "download.directory_upgrade": True,  # Evitar bloqueos de seguridad
    "safebrowsing.enabled": True  # Evitar bloqueos de seguridad
}
chrome_options.add_experimental_option("prefs", prefs)
chrome_options.add_argument("--headless")  # No abrir el navegador
chrome_options.add_argument("--disable-gpu")  # Evitar errores en algunos sistemas
chrome_options.add_argument("--window-size=1920x1080")  # Simular pantalla grande
chrome_options.add_argument("--log-level=3")  # Reducir logs en consola

# Iniciar el navegador de forma visible (sin modo headless)
driver = webdriver.Chrome(options=chrome_options)

# URL de la carpeta de Google Drive
folder_url = "https://drive.google.com/drive/folders/17a0kvZD1ZfRPyMCgrNlr4vCCdqN9djCv"

# Abrir la página de Google Drive
driver.get(folder_url)
time.sleep(5)  # Esperar que cargue la página

# Buscar todos los botones de "Descargar"
try:
    download_buttons = driver.find_elements(By.XPATH, "//span[contains(text(), 'Descargar')]")

    if download_buttons:
        print(f"Se encontraron {len(download_buttons)} archivos para descargar.")

        for button in download_buttons:
            # Intentar hacer clic en el botón de descarga
            try:
                button.click()  # Hacer clic en el botón de descarga

                # Manejar la ventana de alerta si aparece
                try:
                    # Esperar a que el botón "Descargar de todos modos" sea clickeable
                    download_button_alert = WebDriverWait(driver, 10).until(
                        EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Descargar de todos modos')]"))
                    )
                    download_button_alert.click()  # Hacer clic en el botón "Descargar de todos modos"
                    print("¡Ventana de alerta detectada y aceptada!")
                except Exception as e:
                    # Si no se encuentra el botón de la alerta, continuar
                    print("No se encontró la alerta de archivo grande o ya fue procesada.")
                    pass
                time.sleep(5)
                # Verificar si el archivo ya se descargó
                downloaded_files = os.listdir(download_path)
                while  any(file.endswith(".crdownload") or file.endswith(".tmp") for file in downloaded_files):
                    time.sleep(2)
                    downloaded_files = os.listdir(download_path)

            except Exception as e:
                print(f"Error al intentar descargar: {e}")
    else:
        print("No se encontraron archivos para descargar.")

except Exception as e:
    print("Error al buscar los botones de descarga:", e)

# Cerrar el navegador
driver.quit()

