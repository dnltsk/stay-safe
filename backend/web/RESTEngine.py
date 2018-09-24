from aiohttp import web
from datetime import datetime, timedelta
import json

from db.Model import HistogramOccupancy

class RESTEngine:
    def __init__(self, database, timetable):
        self.database = database
        self.timetable = timetable
        self.app = web.Application()
        self.app.add_routes([web.get('/occupancy/hist/at/{date_time}', self.handle_get_occupancy_as_hist_at)])
        self.app.add_routes([web.get('/occupancy/hist/now', self.handle_get_occupancy_as_hist)])
        self.app.add_routes([web.get('/timetable/now', self.handle_get_timetable)])
        self.app.add_routes([web.get('/timetable/at/{date_time}', self.handle_get_timetable_at)])
        self.tbl_nr = 0


    def run(self):
        web.run_app(self.app, port=8000)

    @classmethod
    def entry_to_text(cls, entry):
        return "" if entry is None else str(entry.date_time) + "," + entry.amounts

    async def handle_get_occupancy_as_hist_at(self, request):
        dat_tim_str = request.match_info.get('date_time', None)
        rtxt = ""
        if dat_tim_str is None:
            return self.handle_get_occupancy_as_hist(request)
        try:
            dattim = datetime.strptime(dat_tim_str, '%Y-%m-%d %H:%M:%S')
            entry = self.database.get_occupancy_at(dattim)
            rtxt = self.entry_to_text(entry)
        except Exception as e:
            rtxt = str(e)
            print(e)

        return web.Response(text=rtxt)

    async def handle_get_occupancy_as_hist(self, request):
        entry = self.database.session().query(HistogramOccupancy).order_by(HistogramOccupancy.date_time.desc()).first()
        return web.Response(text=self.entry_to_text(entry))

    def build_timetable_json(self):
        jr = {}
        timetable = []
        if self.timetable.time is not None:
            jr["time"] = str(self.timetable.time)
            for ann in self.timetable.announcements():
                timetable.append({"name": ann.name,
                                  "platform": ann.platform,
                                  "sector": ann.sector,
                                  "arrival": "" if ann.arrival is None else str(ann.arrival)
                                  })

        jr["timetable"] = timetable
        jr["tbl_nr"] = self.tbl_nr
        self.tbl_nr += 1
        jrt = json.dumps(jr)
        return jrt

    async def handle_get_timetable(self, request):
        now = datetime.now()
        self.timetable.update(now)
        jrt = self.build_timetable_json()
        resp = web.Response(text=jrt)
        resp.headers['Access-Control-Allow-Origin'] = '*'
        resp.headers['Content-Type'] = 'application/json'
        return resp

    async def handle_get_timetable_at(self, request):
        dat_tim_str = request.match_info.get('date_time', None)
        jrt = ""
        if dat_tim_str is None:
            return self.handle_get_timetable(request)
        try:
            dattim = datetime.strptime(dat_tim_str, '%Y-%m-%d_%H:%M:%S')
            self.timetable.update(dattim)
            jrt = self.build_timetable_json()
        except Exception as e:
            jrt = str(e)
            print(e)
        resp = web.Response(text=jrt)
        resp.headers['Access-Control-Allow-Origin'] = '*'
        resp.headers['Content-Type'] = 'application/json'
        return resp




