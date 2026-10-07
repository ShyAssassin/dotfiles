pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: deviceInfoSingleton

    property string ramSize: "0GiB"
    property string osName: "unknown"
    property string hostname: "unknown"
    property string username: "クソコードね"

    Process {
        running: true
        id: ramSizeProcess
        command: ["grep", "-oP", "(?<=MemTotal:)[\\d]+", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const gb = parseInt(this.text.trim()) / 1024 / 1024;
                deviceInfoSingleton.ramSize = gb.toFixed(2) + "GiB";
            }
        }
    }

    Process {
        running: true
        id: usernameProcess
        command: ["id", "-un"]
        stdout: StdioCollector {
            onStreamFinished: deviceInfoSingleton.username = this.text.trim()
        }
    }

    Process {
        running: true
        id: osNameProcess
        command: ["grep", "-oP", "(?<=PRETTY_NAME=\")[^\"]+", "/etc/os-release"]
        stdout: StdioCollector {
            onStreamFinished: deviceInfoSingleton.osName = this.text.trim()
        }
    }

    Process {
        running: true
        id: hostnameProcess
        command: ["hostname"]
        stdout: StdioCollector {
            onStreamFinished: deviceInfoSingleton.hostname = this.text.trim()
        }
    }
}
