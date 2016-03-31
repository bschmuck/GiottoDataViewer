import time
import math

from json_setting import JsonSetting
from giotto_helper import GiottoHelper

if __name__ == "__main__":
	giotto_setting = JsonSetting('./giotto_setting.json')
	connector_setting = JsonSetting('./connector_setting.json')
	giotto_helper = GiottoHelper()

	uuids = connector_setting.get('sensor_uuids')
	sampling_rate = connector_setting.get('sampling_rate')

	while True:
		data_array = []
		timestamp = time.time()
		value = math.sin(timestamp/10.) * 50 + 50
		
		for uuid in uuids:
			dic = {}
			dic['sensor_id'] = uuid
			dic['samples'] = [{"time":timestamp,"value":value}]
			dic['value_type']=''
			data_array.append(dic)


		giotto_helper.post_data_array(data_array)
		time.sleep(sampling_rate);
		