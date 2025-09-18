from selenium import webdriver
from selenium.webdriver.common.by import By
import time

filename = "names-a.txt"
# запускаем Chrome
driver = webdriver.Chrome()
driver.get("https://www.calligrapher.ai")

# небольшая задержка, чтобы страница успела полностью прогрузиться
time.sleep(5)

# читаем список имён
with open(filename, "r", encoding="utf-8") as f:
    names = [line.strip() for line in f if line.strip()]

for name in names:
    # поле ввода
    input_field = driver.find_element(By.ID, "text-input")
    input_field.clear()
    input_field.send_keys(name)

    # кнопка Write!
    driver.find_element(By.ID, "draw-button").click()
    time.sleep(1)

    # кнопка Download
    driver.find_element(By.ID, "save-button").click()
    time.sleep(1)  # даём время на скачивание

driver.quit()
