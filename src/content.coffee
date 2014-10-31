# RT Silver
# @author Markus Birth <markus@birth-online.de>

console.log 'RT Silver Main'

cleanElement = (e) ->
    elem = document.getElementById e
    elem?.innerHTML = ''

root = document.getElementsByTagName 'html'
root[0].className = 'gold'

# Inject code to set user to gold
head = document.getElementsByTagName 'head'
Godmode = document.createElement 'script'
Godmode.type = 'text/javascript'
Godmode.text = '''
    var god_attemps = 0;
    function Godmode() {
        if (user != undefined) {
            console.log(\'Found user: %o\', user);
            user.is_gold_user = true;
            user.is_beta_tester = true;
            user.status = \'gold.paid\';
            user.user_type = \'gold.paid\';
        } else {
            if (god_attempts < 100) {
                console.log(\'Retrying...\');
                god_attempts++;
                setTimeout(\'Godmode();\', 100);
            } else {
                console.log(\'Giving up.\');
            }
        }
    }
    Godmode();
    console.log(\'Inject complete.\');
    '''
head[0]?.appendChild(Godmode)

# Need to find a way to modify this before Chrome parses the code
#scripts = document.getElementsByTagName 'script'
#for s in scripts
#    if s.text? and s.text.indexOf('var user') > 0
#        console.log 'Found script: %o', s
#        new_script = s.text
#        new_script = new_script.replace '"is_gold_user":false', '"is_gold_user":true'
#        new_script = new_script.replace '"is_beta_tester":false', '"is_beta_tester":true'
#        new_script = new_script.replace '"status":"basic"', '"status":"gold"'
#        new_script = new_script.replace '"user_type":"basic"', '"user_type":"gold"'
#        s.text = new_script

acc_info = document.getElementsByClassName 'account_info'
if acc_info.length > 0
    acc_info[0].innerHTML = acc_info[0].innerHTML.replace 'Basic  |', '<img src="' + chrome.extension.getURL('rtsilver_16.png') + '" style="vertical-align: sub;" /> Silver  |'

# remove ads
ad_ids = ['add_ad_space', 'gpt-ad-1', 'gpt-ad-2']

for i in ad_ids
    console.log 'Removing DIV#%o', i
    ad = document.getElementById i
    if ad
        ad.parentNode.removeChild ad

# enable features: Cheering
document.enableCheering = ->
    loop
        # after removing 'disabled' class, element vanishes from array, so requery
        nodes = document.getElementsByClassName 'disabled'
        break if nodes.length is 0
        currentNode = nodes.item(0)
        console.log 'Got: %o', currentNode
        if not currentNode
            break
        currentClasses = currentNode.className
        console.log 'Found: %o in %o', currentClasses, currentNode
        newClasses = currentClasses.replace /(?:^|\s)disabled(?!\S)/g, ''
        console.log 'Modified %o to %o', currentClasses, newClasses
        currentNode.className = newClasses

setTimeout('document.enableCheering();', 3000);

# enable features: colored traces - remove gold ad
adnode = document.getElementById 'colored_traces_ad'
if adnode?
    adnode.parentNode.removeChild adnode.nextElementSibling
    adnode.parentNode.removeChild adnode

# enable features: compare trainings
cmp_div = document.getElementsByClassName 'mode off'
cmp_div[0]?.className = 'mode on'
nav_tabs = document.getElementsByClassName 'tabs_navigation'
if nav_tabs.length > 0
    nav_tabs[0].children[1].className = 'tab_me'
    nav_tabs[0].children[1].innerHTML = nav_tabs[0].children[1].children[0].innerHTML
    nav_tabs[0].children[2].className = 'tab_friends last'
    nav_tabs[0].children[2].innerHTML = nav_tabs[0].children[2].children[0].innerHTML

# query script to inject and inject it
chrome.extension.sendMessage {method: "get_script_src"}, (response) ->
    if response isnt ""
        console.log 'Document src to load: %o', response
        head = document.getElementsByTagName 'head'

        newScript = document.createElement 'script'
        newScript.type = 'text/javascript'
        newScript.innerText = '
            window.chart_1_configuration.period_end = (new Date).start().getTime();
            window.chart_1_backup = window.chart_1_configuration;
            console.log("Backup: %o", window.chart_1_backup);

            var head = document.getElementsByTagName("head")[0];
            newScript = document.createElement("script");
            newScript.type = "text/javascript";
            newScript.src  = "' + response + '?blafasel";
            newScript.onload = function() {
                console.log("Script loaded! Backup CFG: %o", window.chart_1_backup);
                window.chart_1_configuration = window.chart_1_backup;
                console.log("Chart 1 CFG: %o", window.chart_1_configuration);
            };
            head.appendChild(newScript);
        '
        head[0].appendChild newScript
        console.log 'Script appended.'
    else
        console.log 'Got no script to load.'
