import csv
import glob

from datetime import datetime

from numpy.matlib import rand, random
from sqlalchemy import func

from db import Database
from db.Model import HistogramOccupancy, Announcement

data_folder = "data"
date_time_format_string = '%d.%m.%Y %H:%M'

delim = ','


csvfile = glob.glob(data_folder+ "/*.csv")

if len(csvfile) == 0:
    print("No data file to import.")
    exit()

if len(csvfile) > 1:
    print("clear data folder before importing.")
    exit()


csvfile_path = csvfile[0]


with open(csvfile_path, 'r') as csvfile:
    db_session = Database.db_session
    spamreader = csv.reader(csvfile, delimiter=delim, quotechar='|')
    prev_arrival = None
    prev_platform = None
    platforms = [1,2,3,4]
    for row in spamreader:
        try:
            arrival = datetime.strptime(row[1], date_time_format_string)
            if arrival == prev_arrival:
                prev_platforms = platforms
                platforms = [x for x in prev_platforms if x != prev_platform]
                random.shuffle(platforms)
                platform = platforms[0]
            else:
                platforms = [1, 2, 3, 4]
                random.shuffle(platforms)
                platform = platforms[0]

            name = row[2]
            ams = ",".join(row[3:])
            if db_session.query(Announcement).filter(Announcement.arrival == arrival).count() == 0:
                entry = Announcement(name=name, platform=platform, arrival=arrival, amounts=ams)
                db_session.add(entry)

            prev_arrival = arrival
            prev_platform = platform
        except Exception as e:
            print(e)

    db_session.commit()

print("done.")