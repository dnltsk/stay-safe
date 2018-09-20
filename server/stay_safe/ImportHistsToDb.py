import csv
import glob

from datetime import datetime

from sqlalchemy import func

from db import Database
from db.Model import HistogramOccupancy


data_folder = "data"
date_time_format_string = '%Y-%m-%dT%H:%M:%SZ'

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
    for row in spamreader:
        try:
            dattim = datetime.strptime(row[1], date_time_format_string)
            ams = ",".join(row[2:-1])
            if db_session.query(HistogramOccupancy).filter(HistogramOccupancy.date_time == dattim).count() == 0:
                entry = HistogramOccupancy(date_time=dattim, amounts=ams)
                db_session.add(entry)
        except Exception as e:
            print(e)

    db_session.commit()

print("done.")