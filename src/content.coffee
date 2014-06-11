console.log 'RT Silver'

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
            user.status = \'gold\';
            user.user_type = \'gold\';
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
head[0].appendChild(Godmode)

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

# enable features: colored traces - remove gold ad
adnode = document.getElementById 'colored_traces_ad'
if adnode?
    adnode.parentNode.removeChild adnode.nextElementSibling
    adnode.parentNode.removeChild adnode

setTimeout('document.enableCheering();', 3000);
