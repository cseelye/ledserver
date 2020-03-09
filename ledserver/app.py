import connexion
from pathlib import Path
from pystatusb import StatUSB


def list_leds():
    leds = []
    for devname in StatUSB.list_devices():
        led = StatUSB(device=devname)
        try:
            leds.append({"device": Path(devname).name,
                         "type":"statusb",
                         "color": led.get_color(),
                        })
        except (OSError, ValueError):
            pass
    return leds

def get_led(led_dev):
    led = StatUSB(device="/dev/{}".format(led_dev))
    return {"device":led_dev,
            "type":"statusb",
            "color": led.get_color()
           }

def get_led_color(led_dev):
    led = StatUSB(device="/dev/{}".format(led_dev))
    return led.get_color()

def set_led_color(led_dev, color):
    led = StatUSB(device="/dev/{}".format(led_dev))
    return led.set_color_rgb(color)

def set_led_fade(led_dev, fade_time):
    led = StatUSB(device="/dev/{}".format(led_dev))
    return led.set_transition_time(fade_time)

def set_led_sequence(led_dev, sequence):
    led = StatUSB(device="/dev/{}".format(led_dev))
    return led.set_sequence(sequence)


app = connexion.App(__name__, specification_dir='openapi/')
app.add_api("ledserver.yaml")
application = app.app


if __name__ == "__main__":
    app.run(port=8080)
