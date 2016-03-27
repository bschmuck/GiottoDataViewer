import requests
import time
import json
import time
import calendar
from json_setting import JsonSetting 

class GiottoHelper:
    def __init__(self, settingFilePath="./giotto_setting.json"):
        setting = JsonSetting(settingFilePath)
        self.giotto_rest_api = setting.get('giotto_rest_api')
        self.gateway = setting.get('gateway')

    def post_data_array(self, data_array):
        headers = {'content-type': 'application/json'}
        url = 'http://' + self.giotto_rest_api['server']
        url += ':' + self.giotto_rest_api['port'] 
        url += self.giotto_rest_api['api_prefix'] + '/timeseries'
        result = requests.post(url, data=json.dumps(data_array), headers=headers)

    def post_log(self, level, event, detail):
        headers = {'content-type': 'application/json'}
        url = 'http://' + self.giotto_rest_api['server'] + ':' + self.giotto_rest_api['port']
        url += '/log'

        log = {
            "time":time.time(),
            "event":event,
            "detail":detail,
            "gateway_name":self.gateway['name'],
            "level":level
        }

        result = requests.post(url, data=json.dumps(log), headers=headers)

    def post_data_array_old(self, sensor_id, data_array):
        headers = {'content-type': 'application/json'}
        url = 'http://' + self.giotto_rest_api['server']
        url += ':' + self.giotto_rest_api['port'] 
        url += '/service/sensor/' + sensor_id + '/timeseries'

        dic = {'data':data_array}
        result = requests.post(url, data=json.dumps(dic), headers=headers)
        return result.text        

if __name__ == "__main__":
    pass
    



