pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: timeSingleton

    property string hmTime
    property string hmsTime
    property string unixTime
    property string kanjiTime
    property string kanjiWeekday

    Process {
        running: true
        id: hmTimeProcess
        command: ["date", "+%H:%M"]
        stdout: StdioCollector {
            onStreamFinished: timeSingleton.hmTime = this.text.trim()
        }
    }

    Process {
        running: true
        id: hmsTimeProcess
        command: ["date", "+%H:%M:%S"]
        stdout: StdioCollector {
            onStreamFinished: timeSingleton.hmsTime = this.text.trim()
        }
    }

    Process {
        running: true
        id: unixTimeProcess
        command: ["date", "+%s"]
        stdout: StdioCollector {
            onStreamFinished: timeSingleton.unixTime = this.text.trim()
        }
    }

    Process {
        running: true
        id: kanjiTimeProcess
        command: ["sh", "-c", `
            h=$(date +%H)
            m=$(date +%M)
            if [ "$m" -eq 0 ]; then
                echo "\${h}時"
            elif [ "$m" -eq 30 ]; then
                echo "\${h}時半"
            else
                echo "\${h}時\${m}分"
            fi
        `]
        stdout: StdioCollector {
            onStreamFinished: timeSingleton.kanjiTime = this.text.trim()
        }
    }

    Process {
        running: true
        id: kanjiWeekdayProcess
        command: ["sh", "-c", `
            case $(date +%u) in
                1) echo "月" ;;
                2) echo "火" ;;
                3) echo "水" ;;
                4) echo "木" ;;
                5) echo "金" ;;
                6) echo "土" ;;
                7) echo "日" ;;
                *) echo "やばい" ;;
            esac
        `]
        stdout: StdioCollector {
            onStreamFinished: timeSingleton.kanjiWeekday = this.text.trim()
        }
    }

    Timer {
        repeat: true
        running: true
        interval: 1000
        id: updateTimer
        onTriggered: {
            hmTimeProcess.running = true
            hmsTimeProcess.running = true
            unixTimeProcess.running = true
            kanjiTimeProcess.running = true
            kanjiWeekdayProcess.running = true
        }
    }
}
