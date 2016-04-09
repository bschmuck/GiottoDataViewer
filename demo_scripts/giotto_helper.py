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
        self.ml_rest_api = setting.get('ml_rest_api')
        self.gateway = setting.get('gateway')
        self.oauth = setting.get('oauth')
        self.access_token = self.get_oauth_token()
        print self.access_token

    def post_data_array(self, data_array):
        headers = {
            'content-type': 'application/json',
            'Authorization': 'Bearer ' + self.access_token
            }
        url = 'http://' + self.giotto_rest_api['server']
        url += ':' + self.giotto_rest_api['port'] 
        url += self.giotto_rest_api['api_prefix'] + '/sensor/timeseries'

        result = requests.post(url, data=json.dumps(data_array), headers=headers)
        print result

    def get_oauth_token(self):
        headers = {'content-type': 'application/json'}
        url = 'http://' + self.giotto_rest_api['server']
        url += ':' + self.giotto_rest_api['port'] 
        url += '/oauth/access_token/client_id='
        url += self.oauth['id']
        url += '/client_secret='
        url += self.oauth['key']
        result = requests.get(url, headers=headers)

        if result.status_code == 200:
            dic = result.json()
            return dic['access_token']
        else:
            return ''

if __name__ == "__main__":
    giotto_helper = GiottoHelper()
    



