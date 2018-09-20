import random
from datetime import timedelta, datetime

import numpy

from db.Model import Announcement
from timetable.LineAnnouncement import LineAnnouncement



class Timetable:
    LineNames = ["S3", "S5", "S6", "S7", "S9", "S11", "S12", "S15", "S16", "S21"]

    #StartTime = datetime.strptime("21.06.2018 04:46", "%d.%m.%Y %H:%M")

    def __init__(self, database):
        self.database = database
        self.east_lines = {}
        self.west_lines = {}
        self.time = None

        self.init_lines()


    def init_lines(self):
        for name in self.LineNames:
            self.east_lines[name] = LineAnnouncement(name)
            self.west_lines[name] = LineAnnouncement(name)

    def reset(self):
        self.time = None
        self.init_lines()

    def update_location_referrals(self, announcements):
        margin = 55
        sectors = ["A", "B", "C", "D", "E", "F"]
        for ann in announcements:
            arrival = ann.arrival
            if arrival is None:
                continue

            train_busy = [int(x) for x in ann.amounts.split(",")]
            hist_occ = self.database.get_occupancy_at(self.time)

            if hist_occ is None:
                #val, idx = min((val, idx) for (idx, val) in enumerate(train_busy))
                ann.sector = ""
            else:
                # check if hist is about equaly distributed:
                # todo NA's in histograms
                plat_busy = [int(x) if x != "NA" else margin for x in hist_occ.amounts.split(",")]
                idx = 0
                if max(plat_busy) - min(plat_busy) < margin:
                    idx = random.sample(range(len(plat_busy)),1)[0]
                else:
                    # todo: remove flickering
                    args = numpy.argsort(plat_busy)
                    if (plat_busy[args[1]] - plat_busy[args[0]]) > margin:
                        idx = args[0]
                    else:
                        idx = args[1] if train_busy[args[1]] < train_busy[args[0]] else args[0]

                ann.sector = sectors[idx]

    def update(self, now):
        # if browser got refreshed, reset timetable
        if (self.time is not None) and (self.time > now + timedelta(seconds=600)):
            self.reset()

        self.time = now

        print(self.time)
        start = now - timedelta(seconds=60)
        end = start + timedelta(seconds=3600)

        announcements = self.database.session().query(Announcement)\
                                       .filter(Announcement.arrival >= start)\
                                       .filter(Announcement.arrival <= end)\
                                       .order_by(Announcement.arrival.asc())

        checked_east = {}
        checked_west = {}

        # for each line and direction, set the next connection
        for ann in announcements:
            name = ann.name
            platform = ann.platform
            east_line_update = platform < 3
            arrival = ann.arrival
            amounts = ann.amounts


            if name not in self.LineNames:
                continue

            if east_line_update:
                if self.east_lines[name].arrival is None or self.east_lines[name].arrival < self.time:
                    self.east_lines[name].platform = platform
                    self.east_lines[name].arrival = arrival
                    self.east_lines[name].amounts = amounts
                    print("EAST Setting {0} to arrival {1} on platform{2}".format(name, arrival, platform))
                checked_east[name] = 1
            else:
                if self.west_lines[name].arrival is None or self.west_lines[name].arrival < self.time:
                    self.west_lines[name].platform = platform
                    self.west_lines[name].arrival = arrival
                    self.west_lines[name].amounts = amounts
                    print("WEST Setting {0} to arrival {1} on platform{2}".format(name, arrival, platform))
                checked_west[name] = 1

            if (len(checked_east) == len(self.LineNames)) and\
                (len(checked_east) == len(self.LineNames)):
                print("Done.")
                break

        # based on next connection -> determine best sector for people to go

        self.update_location_referrals(self.east_lines.values())
        self.update_location_referrals(self.west_lines.values())



    def announcements(self):
        return [v for v in self.east_lines.values()] + [v for v in self.west_lines.values()]

