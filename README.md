# redisamldocker
Redis AML Demo with Docker (Redis/Search/CDC/Postgres/Insight)
![redisaml](https://user-images.githubusercontent.com/76743844/131912137-b405a0a1-cb73-45c7-a711-9b34afe4cc23.png)
Documentation on the files included:
https://docs.google.com/document/d/1kotAZ_MvAIIp_GJfJ5pCmduJ0PkKLV8Pr3DThqD-Il4/edit

Pre requisites:
1. Create Anaconda Environment:
   conda create --name redisaml-env
2. Activate Anaconda Environment:
   conda activate redisaml-env
3. Install Libraries:
   pip install requirements.txt
4. Change settings in Docker Desktop: Change CPUs to allow at least 4 CPUs and increase the total memory. I got it working with 8GB RAM. But you can experiment with    it. Add the folder /Users/[username]/redisamldocker to file sharing to allow the containers to use local resources. Remember to replace [username] with your mac    username.

To execute run:
sudo ./redisaml.sh


## Start the Search app API

From the main repo directory:
```
(venv) redisaml$ python app.py 
 * Serving Flask app "app" (lazy loading)
 * Environment: production
 ...
```

## Example Redisearch Queries

Which cases contain the word 'society' in casebody:
``` 
ft.search cases "world" RETURN 1 casebody SUMMARIZE HIGHLIGHT
```
Which cases have the status 'new':
```
ft.search cases "@status:{new}" RETURN 0 LIMIT 0 15
```
How many cases are there of specific status? 
```
ft.aggregate cases * GROUPBY 1 @status REDUCE COUNT 0
```
What is the total Value of cases under investigation by status?
```
ft.aggregate cases * GROUPBY 1 @status REDUCE sum 1 value as Category_Case_Value
```
Find the terms 'capital' or 'economy' in files associated with *any* case:
```
ft.search files "capital |economy" RETURN 1 body SUMMARIZE HIGHLIGHT LIMIT 0 4
1) (integer) 1687
2) "file:afce89c82df44934b593a6bc44b95e12"
3) 1) "body"
   2) "color. Another amount firm parent real voice. Animal <b>capital</b> step dog. To sign recent activity. Identify allow political...  Player happy green spring magazine sport. On front wonder <b>capital</b>. <b>Economy</b> within policy computer central. Here mean need perhaps our... "
4) "file:7956248de91e479b81e61b95a9582d67"
5) 1) "body"
   2) "choose true explain its management force. Page child kid. <b>Capital</b> brother keep then white also opportunity kitchen. Police... like ago despite budget body. Cell turn long when eight <b>capital</b>. As fact responsibility ago. Language career drug. Score... similar. Outside end arm person. Hundred week nothing five <b>capital</b> very current study. Mouth policy relationship. Evening... "
6) "file:1f608bf7faf6445b9df46e26ac2f6b03"
7) 1) "body"
   2) "Usually current everybody top attack bit trip. Next <b>capital</b> past administration glass six health. Successful staff... "
8) "file:0031baed6be3442f8f510663058ffb6b"
9) 1) "body"
   2) "office left. Officer with home hundred letter. Anything <b>economy</b> material the. Himself strategy leg speech system one camera... choose. Budget clearly two fall place. Quality should <b>economy</b> thought outside. You mind plan. Improve blood write sort... Change tree perhaps worry service. Computer save usually <b>economy</b>. Citizen chance box deep. Develop carry next personal ready... "
``` 

Find the terms 'building in the files associated with a specific case:
```
ft.search files "building @caseid:{10320000064}" RETURN 1 body SUMMARIZE HIGHLIGHT LIMIT 0 4
1) (integer) 166
2) "file:75f089fc65ee495d9e71711dcaae8397"
3) 1) "body"
   2) "cultural. Report apply across. Trip hold <b>building</b> chance truth office. Interest box <b>building</b> Democrat look. Speak help without piece... "
4) "file:603a243c46574cee8692d7c05bb42cd9"
5) 1) "body"
   2) "claim you. New deep professional control above successful <b>building</b>. Want wonder evening itself wind. Fish miss who year. Seek...  Seek especially model. Partner feel should loss. Agent <b>building</b> middle off reveal. Fact try nothing cultural character ok... "
6) "file:25f66202f5c642ef9ab3ee4f95c693de"
7) 1) "body"
   2) "try real. Financial character sea agreement seek produce <b>building</b>. Never view order. Different color father. Leader study she... she stuff away. Scientist four election commercial cause <b>building</b>. Big return from us right try. Range clearly me... "
8) "file:05a46732fe584c55b53a549da7ab52c5"
9) 1) "body"
   2) "decision. Analysis these avoid ago. Bar hear at. Fast more <b>building</b> keep. Manage board then left southern travel. President... full. Sea movie pattern shoulder audience open middle sea. <b>Building</b> land remember better general address end. Successful game... "
```



## Example API Requests

Note: Results return as JSON. If you want to render the UI add `render=1` as a URL param.

* `http://localhost:5000/search?val_min=1000&val_max=10000&count=2`
* `http://localhost:5000/search?render=1&val_min=1000&val_max=10000&count=2`
* `http://localhost:5000/search?val_min=1000&val_max=10000&count=12&search_str=industry`
* `http://localhost:5000/search?val_min=1000&val_max=10000&count=12&tag_str=41923764`
* `http://localhost:5000/filesearch?search_str=parent`
* `http://localhost:5000/filesearch?search_str=Book&filetype=csv`
* `http://localhost:5000/filesearch?summarize=true&caseid=10320005755&search_str=51966904`
* Individual record: `https://localhost:5000/10320001606`


