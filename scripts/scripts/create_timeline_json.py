import csv, sys, json


    

food_item_map={"data":{}}
csv_read_path="../csv/timeline.csv"
json_write_path="../json/timeline.json"



with open(csv_read_path, "r",encoding='utf-8-sig') as f:
    data = csv.reader(f, delimiter=',', quotechar='"')

    for row in data:
        print(len(row))
        if row[0]:
            timeline_string=row[0]
            timeline_id=timeline_string.split('_')[1]
            timeline_lable=row[1]
            timeline_day=row[2]
            set_list=[]
            set_list_id=timeline_string.split('_')[3]
            ytVideoID=row[3].strip()
            ytVideoTitle=row[4]
            ytVideoAuthor=row[5]
            for i in range(6, len(row)):
                if(row[i].strip()):
                    set_list.append(row[i])

            if timeline_id in food_item_map["data"].keys():
                if "timeline_set" in food_item_map["data"][timeline_id] and set_list :
                    timeline_set=food_item_map["data"][timeline_id]["timeline_set"]
                    timeline_set[set_list_id]=set_list
                    food_item_map["data"][timeline_id]["timeline_set"]=timeline_set
                if "youtube" in  food_item_map["data"][timeline_id] and ytVideoID:
                    youtubeList=food_item_map["data"][timeline_id]["youtube"]
                    youtubeList.append({
                        "video_id":ytVideoID,
                        "video_title":ytVideoTitle,
                        "video_author":ytVideoAuthor
                     })
                    food_item_map["data"][timeline_id]["youtube"]=youtubeList
                     
                        

            else :
   
                time_line_obj={}
                time_line_obj["timeline_id"]=timeline_id
                time_line_obj["timeline_lable"]=timeline_lable
                time_line_obj["timeline_day"]=timeline_day
                time_line_obj["timeline_set"]={}
                time_line_obj["youtube"]=[]

                
                if ytVideoID:
                    
                     time_line_obj["youtube"].append({
                        "video_id":ytVideoID,
                        "video_title":ytVideoTitle,
                        "video_author":ytVideoAuthor
                     })
                    


                if set_list:
                    time_line_obj["timeline_set"]={set_list_id:set_list}
                
                food_item_map["data"][timeline_id]=time_line_obj

           
    
            


with open(json_write_path, "w") as outfile:
    json.dump(food_item_map, outfile)