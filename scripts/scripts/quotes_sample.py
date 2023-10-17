import csv, sys, json


    

food_item_map=[]
csv_read_path="../csv/relapse_quotes.csv"
json_write_path="../json/quotes_sample.json"



with open(csv_read_path, "r",encoding='utf-8-sig') as f:
    data = csv.reader(f, delimiter=',', quotechar='"')

    for row in data:
        if not row[3]:
            continue
        quote=row[0].strip()
        author=row[1].strip()
        day=int(row[2].strip())
        image_url=row[3].strip()




        recipe_detail_map={
                        "day":day,
                        "author":author,
                        "quote":quote,
                        "image_url":image_url
        }




        food_item_map.append(recipe_detail_map)

    
            


with open(json_write_path, "w") as outfile:
    json.dump(food_item_map, outfile)