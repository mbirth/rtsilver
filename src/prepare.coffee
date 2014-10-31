# RT Silver Prepare

console.log 'RT Silver prepare'

s = document.createElement 'script'
s.innerText = '
    window.chart_1_configuration = {
        users: [],
        sport_types: [1],
        field: "count",
        compare: "",
        period: "day",
        period_end: (new Date).value,
        kind: 0,
        initial_expand: "yes",
        container: "#chart_1_js",
        instance: {},
        lock: !1
    };

    window.chart_2_configuration = {
        users: [],
        sport_types: [1],
        field: "count",
        compare: "",
        period: "day",
        period_end: (new Date).value,
        kind: 1,
        initial_expand: "yes",
        container: "#chart_2_js",
        instance: {},
        lock: !1
    };
'

(document.head or document.documentElement).appendChild s

#console.log 'This is the document: %o', document.documentElement
#console.log 'HEAD at: %o', document.documentElement.indexOf('<head')

# remove javascript to run later
#scripts = document.getElementsByTagName 'script'
#for s in scripts
#    if s.src.indexOf('statistics_history') isnt -1
#        console.log 'Found script: %o', s
#        document.rtsilver.script_src = s.src
#        s.parentNode.removeChild s
#        break
