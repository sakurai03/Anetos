##########
#処理名：推奨洋服を取得する
#仕様：
#・翌日日付の天気情報を取得する
#
##########

##########
#初期設定
##########
#ライブラリの読み込み
require "active_record"
require "date"

#ActiveRecordの設定
ActiveRecord::Base.establish_connection(
	"adapter" => "sqlite3",
	"database" => "/home/ec2-user/test2/db/development.sqlite3"		)

#########
#ユーザテーブルからユーザID、地域IDを取得する
#########
#ユーザテーブル用のクラスを作成
class User < ActiveRecord::Base
end

#天気テーブル用のクラスを作成
class Weather < ActiveRecord::Base
end


#推奨TB用のクラスを作成
class Recommend < ActiveRecord::Base
end

#ユーザテーブルの最終行を取得する
i = User.last.id

#翌日日付を取得し、String型に変換
dt = Date.today + 1
dt = dt.strftime("%Y-%m-%d")
dt = dt+" 09:00:00"

#全ユーザのユーザID、地域IDを取得
i.times do |j|
	j = j + 1
	user_id = User.find(j).id
	puts user_id
	region_id = User.find(j).region_id
	#下記は開発用コード
	#puts user_id
	#puts region_id
	#puts "-------"
	
	#取得した地域IDから天気情報を配列に格納
	weather_data = Weather.where(region_id: region_id).map{|p| p.attributes }
	#下記は開発用コード
	#puts weather_data.length
	#puts weather_data[0]["time"]
	#puts dt
	#puts weather_data

	#翌日分のレコードのみ抽出
	k = weather_data.length
	#気温情報格納用配列
	
	k.times do |l|
		temp = Array.new
		#weather_data[l]["time"]に当日日付が含まれているか判定
		m = weather_data[l]["time"]
		#puts dt
		#puts m
		if m.include?(dt) then
			#取得した気温情報を配列に格納
			temp.push(weather_data[l]["temperature"])
			puts "配列表示"
			puts weather_data[l]["time"]
			puts temp
			#puts temp[0].class
			temp = temp[0].to_i
			
				#気温に応じてタグIDの洋服をInsert

			if temp>=25 then
				puts temp
				puts ("SO HOT!!")
			
			elsif 20<=temp && temp<25 then
				puts temp
				puts ("HOT!!")
			
			elsif 15<=temp && temp<20 then
				puts temp
				puts ("WARM!!")
			
			elsif 10<=temp && temp<15 then
				puts temp
				puts ("FeelGood!!")
			
			elsif 5<=temp && temp<10 then
				puts temp
				puts ("cool!!")
			
			elsif temp<5 then
				puts temp
				puts ("cold!!")
			end
		#else
			#puts "当日日付が含まれていません"
		end
	end
end