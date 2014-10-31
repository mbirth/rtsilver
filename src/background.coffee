# RT Silver Background

chrome.runtime.onInstalled.addListener ->
    chrome.declarativeContent.onPageChanged.removeRules undefined, ->
        chrome.declarativeContent.onPageChanged.addRules [
            {
                conditions: [
                    new chrome.declarativeContent.PageStateMatcher {
                        pageUrl: { urlContains: 'www.runtastic.com' }
                    }
                ]
                actions: [ new chrome.declarativeContent.ShowPageAction() ]
            }
        ]

killswitch = true
script_src = ''

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if request.method is "get_script_src"
        killswitch = false
        sendResponse script_src
    else
        sendResponse {}


# Prevent statistics_history script from loading
chrome.webRequest.onBeforeRequest.addListener(
    (details) ->
        console.log 'Cock-blocked! %o', details
        script_src = details.url
        return {cancel: killswitch}
    ,
    {
        urls: [
            "*://*.cloudfront.net/*/statistics_history-*"
        ]
    },
    ["blocking"]
)
