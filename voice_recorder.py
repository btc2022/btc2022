import sounddevice as sd
import scipy.io.wavfile as wav
import numpy as np
import time
from datetime import datetime

def main():
    try:
        duration = float(input("Enter recording duration in seconds: "))
        if duration <= 0:
            print("Duration must be positive.")
            return
        
        fs = 44100  # Sample rate
        print(f"Recording for {duration} seconds... Speak into the microphone!")
        print("Press Ctrl+C to stop early if needed.")
        
        recording = sd.rec(int(duration * fs), samplerate=fs, channels=1, dtype=np.float32)
        sd.wait()  # Wait until recording is finished
        time.sleep(0.5)  # Short pause to ensure completion
        
        # Convert to int16 for WAV
        audio_int16 = (recording * 32767).astype(np.int16).flatten()
        
        # Generate filename with timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"recording_{timestamp}.wav"
        
        wav.write(filename, fs, audio_int16)
        print(f"Recording saved as {filename}")
        
    except KeyboardInterrupt:
        print("\nRecording stopped by user.")
    except Exception as e:
        print(f"Error: {e}")
        print("Make sure you have a microphone and libraries installed.")

if __name__ == "__main__":
    main()

