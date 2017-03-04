#OpenWeatherMapの設定
API_KEY = "5f2693556616b7c61455f0f3d49d1743"
BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"

require "json"
require "open-uri"
require "active_record"
require "json"
require "time"

#ActiveRecrodのタイムゾーンの設定
Time.zone_default = Time.find_zone! 'Tokyo'
ActiveRecord::Base.default_timezone = :local


#ActiveRecordの設定
ActiveRecord::Base.establish_connection(
	"adapter" => "sqlite3",
	"database" => "/home/ec2-user/test2/db/development.sqlite3"
)

##########
#地域テーブルから地域名を取得
##########
#地域テーブル用のクラスを作成
class Region < ActiveRecord::Base
end

#地域テーブルの最終行を取得する
i = Region.last.id

#配列を用意してその中にctiy_nameを格納する
array = Array[]
i.times do |j|
	j = j + 1
	city_name = Region.find(j).city_name
	array.push(city_name) 
end

##########
#openweathermapから気温を取得する
##########
#天気テーブル用のクラスを作成
class Weather < ActiveRecord::Base
end

array.each do |k|
	response = open(BASE_URL + "?q=#{k},jp&APPID=#{API_KEY}")
	#デバック用
	#puts k
	json_data = JSON.pretty_generate(JSON.parse(response.read))
	#puts json_data
	json = JSON.parser.new(json_data)
	hash = json.parse()
	#city_nameを取得する
	city_name = hash["city"]["name"]
	puts city_name
	city_id = Region.find_by_city_name(city_name).id
	puts city_id
	info = hash["list"]
	#hashの数を数えるためのテストコード
	#puts time.length
	#timeを取得する
	l = info.length
	l.times do |m|
		#時刻を取得する
		puts info[m]["dt_txt"]
		date_time = info[m]["dt_txt"]
		#時刻をJSTに変換する
		date_time_jst = Time.parse(date_time)
		#JSTなので9時間足す
		date_time_jst = date_time_jst + (9 * 60 * 60)
		#天気ステータスを取得する
		puts info[m]["weather"][0]["description"]
		weather_status = info[m]["weather"][0]["description"]
		#気温を取得する(ケルビンから摂氏に変換含む)
		puts info[m]["main"]["temp"] - 273.15
		temp = info[m]["main"]["temp"] - 273.15
		#天気テーブルにデータ挿入
		Weather.create(:region_id => city_id,:time => date_time_jst,:weather=> weather_status,:temperature => temp )
	end
	
end
