# Python Voice Recorder

Простой голосовой рекордер на Python. Записывает звук с микрофона в .wav файл за несколько строк кода.

## 📦 Установка

1. Создайте виртуальное окружение:
   ```
   python -m venv venv
   ```

2. Активируйте (Windows):
   ```
   venv\\Scripts\\activate
   ```

3. Установите зависимости:
   ```
   pip install -r requirements.txt
   ```

**Примечание для Windows:** Если ошибка с sounddevice, установите PortAudio:
- Скачайте с https://www.portaudio.com/download.html (Windows binary).
- Или используйте conda: `conda install portaudio`.

## 🚀 Запуск

```
python voice_recorder.py
```

- Введите количество секунд для записи (например, 5).
- Нажмите Enter — начнется запись.
- Говорите в микрофон.
- Файл сохранится как `recording_YYYYMMDD_HHMMSS.wav`.

## Пример

```
Enter recording duration in seconds: 10
Recording for 10.0 seconds... Speak into the microphone!
Recording saved as recording_20241005_143022.wav
```

## 🛠️ Файлы

- `voice_recorder.py` — основной скрипт.
- `requirements.txt` — зависимости.
- `TODO.md` — прогресс.

Готово к использованию в проектах, видео или подкастах!

