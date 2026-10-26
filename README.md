# ☁️ Cloudflare Tunnel для Sonoff iHost (32-bit ARMv7)

Свежий, автоматически обновляемый Docker-образ клиента **Cloudflare Tunnel (`cloudflared`)**, адаптированный специально под аппаратные особенности и ограничения веб-интерфейса **SONOFF iHost (eWeLink CUBE)**.

---

## 🔍 Зачем нужен этот образ?

1. **32-битная архитектура (`linux/arm/v7`):**  
   Sonoff iHost работает на процессорах Rockchip RV1109 / RV1126 (Cortex-A7, 32-bit). Официальный образ `cloudflare/cloudflared` не поддерживает 32-битный ARM (выдает ошибку `no matching manifest for linux/arm/v7`).
2. **Устаревание старого образа `duongthanhvu/cloudflared-ihost`:**  
   Популярный в сообществе 4PDA образ был заброшен автором в апреле 2025 года (версия `2025.4.0`), из-за чего в Cloudflare Zero Trust загорелся статус `Unsupported`.
3. **Баг веб-интерфейса eWeLink CUBE в поле `Command`:**  
   При попытке запустить современный `erisamoe/cloudflared` через команду `tunnel run`, iHost передает строку в Docker как один неделимый аргумент `"tunnel run"` (с пробелом). В итоге Go-бинарник Cloudflare выкидывает ошибку:  
   `You did not specify any valid additional argument to the cloudflared tunnel command`.

**Решение:** В этом образе команда `CMD ["tunnel", "run"]` **заранее правильно зашита в манифест**. На iHost поле **Command** остаётся **ПУСТЫМ**, а образ всегда обновляется до свежего релиза.

---

## 🚀 Быстрый запуск на Sonoff iHost (eWeLink CUBE)

1. Откройте интерфейс iHost: `http://192.168.34.3/`
2. Перейдите в раздел **Docker** → вкладка **Image** (Образы) → нажмите **Download Image**.
3. Введите имя образа:  
   ```text
   nikovsk1/cloudflared-ihost:latest
   ```
4. После скачивания нажмите **Run** и укажите параметры:
   * **Network:** `host`
   * **Environment variables (Переменные окружения):**
     * Name: `TUNNEL_TOKEN`
     * Value: *ваш токен туннеля из Cloudflare Zero Trust (начинается на `eyJ...`)*
     * Обязательно нажмите **синий значок `+` справа** от строки!
   * **Command (Команда запуска):** **ОСТАВЬТЕ ПОЛНОСТЬЮ ПУСТЫМ!**
   * **Volume:** диск не требуется (оставьте пустым).
   * **Restart Policy:** `Always`
5. Нажмите **Run**.

В панели Cloudflare Zero Trust статус туннеля сразу станет зеленым **`HEALTHY`** с актуальной версией!

---

## ⚙️ Автоматическая сборка в GitHub Actions

В репозиторий встроен автоматический сценарий сборки:
* Сборка многоплатформенного образа (`linux/arm/v7`, `linux/arm64`, `linux/amd64`) на базе ядра `erisamoe/cloudflared`.
* Автоматическая пересборка 1-го числа каждого месяца для подтягивания самых свежих релизов Cloudflare.
* Ручной запуск в любой момент через вкладку **Actions** → **Run workflow**.

### Необходимые секреты репозитория (Settings → Secrets and variables → Actions):
* `DOCKERHUB_USERNAME`: ваш логин на hub.docker.com (например, `nikovsk1`).
* `DOCKERHUB_TOKEN`: ваш Personal Access Token от Docker Hub (создается на hub.docker.com → Account Settings → Security → New Access Token).
