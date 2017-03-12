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

#洋服テーブル用のクラスを作成
class Clothe < ActiveRecord::Base
end

#推奨TB用のクラスを作成
class Recommend < ActiveRecord::Base
end

#変数定義
harf_tshirt = 3
long_tshirt = 4
harf_shirt = 5
long_shirt = 6
tunic = 9
cardigan = 10
jacket = 11
one_piece = 12
long_skirt = 13
harf_skirt = 14
short_skirt = 15
long_pants = 16
harf_pants = 17
short_pants = 18
hat = 22
sneaker = 30
leather_shoes = 31
sandal = 34
pumps = 35

#25度以上洋服選択処理
def selectClothes25(user_id,dt)
	firstLayer = []
	puts "user_id:" + user_id.to_s
	firstLayer = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,harf_tshirt,one_piece,tunic).map{|p| p.attributes }
	p firstLayer.class
	if firstLayer.length == 0 then
		puts "この人は１層目を持っていません"
		puts firstLayer
	else
		puts "この人は１層目を持っています"
		#puts firstLayer
		#抽出したTシャツの中から1つランダムで選択
		t = rand(firstLayer.length)
		p firstLayer[t]
		puts firstLayer[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => firstLayer[t]["id"],:date => dt)
		#もし選択した1層目がTシャツ（半袖）:3 だった場合、シャツ（半袖）:5 も有り
		if firstLayer[t]["tag_id"] == 3 then
			u = rand(1)
			#0だった場合はシャツ（半袖）あり
			if u == 0 then
				secondlayer = Clothe.where("user_id = ? AND tag_id = ?",user_id,harf_shirt).map{|p| p.attributes }
				if secondlayer.length == 0 then
					puts "この人は2層目を持っていません"
				else
					puts "この人は2層目を持っています"
					puts secondlayer
					t = rand(secondlayer.length)
					p secondlayer[t]
					puts secondlayert]["id"]
					Recommend.create(:user_id => user_id,:cloth_id => secondlayer[t]["id"],:date => dt)
				end
			end
		end
		#選択したトップスがワンピース以外であれば、ボトムスを選択する
		unless firstLayer[t]["tag_id"] == one_piece then
			bottoms = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,short_pants,harf_pants,short_skirt,harf_skirt).map{|p| p.attributes }
			if bottoms.length == 0 then
				puts "このひとはボトムスを持っていません"
			else
				puts "このひとはボトムスを持っています"
				t = rand(bottoms.length)
				p bottoms[t]
				puts bottoms[t]["id"]
				Recommend.create(:user_id => user_id,:cloth_id => bottoms[t]["id"],:date => dt)
			end
		end
		#靴を選択
		shoes = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ?)",user_id,sneaker,sandal).map{|p| p.attributes }
		if shoes.length == 0 then
			puts "このひとは靴を持っていません"
		else
			puts "このひとは靴を持っています"
			t = rand(shoes.length)
			p shoes[t]
			puts shoes[t]["id"]
			Recommend.create(:user_id => user_id,:cloth_id => shoes[t]["id"],:date = dt)
		end
		#その他を選択
		hats = Clothe.where("user_id = ? AND tag_id = ?",user_id,hat)
		if hats.length == 0 then
			puts "このひとは帽子を持っていません"
		else
			puts "このひとは帽子をもっています"
			u = rand(1)
			t = rand(hats.length)
			#0だった場合は帽子あり
			if u == 0 then
				Recommend.create(:user_id => user_id,:cloth_id => hats[t]["id"],:date = dt)
			end
		end
	end
end

#20度以上25度以下洋服選択処理
def selectClothes20(user_id,dt)
	firstLayer = []
	puts "user_id:" + user_id.to_s
	firstLayer = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,harf_tshirt,long_tshirt,tunic).map{|p| p.attributes }
	p firstLayer.class
	if firstLayer.length == 0 then
		puts "この人は１層目を持っていません"
		puts firstLayer
	else
		puts "この人は１層目を持っています"
		#puts firstLayer
		#抽出した1層目の中から1つランダムで選択
		t = rand(firstLayer.length)
		p firstLayer[t]
		puts firstLayer[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => firstLayer[t]["id"],:date => dt)
		#もし選択した1層目がTシャツ（半袖）:3 だった場合、シャツ（半袖）:5 とシャツ（長袖）:6も有り
		if firstLayer[t]["tag_id"] == 3 then
			secondlayer = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id)",user_id,harf_shirt,long_shirt).map{|p| p.attributes }
			if secondlayer.length == 0 then
				puts "この人は2層目を持っていません"
			else
				puts "この人は2層目を持っています"
				puts secondlayer
				t = rand(secondlayer.length)
				p secondlayer[t]
				puts secondlayert]["id"]
				Recommend.create(:user_id => user_id,:cloth_id => secondlayer[t]["id"],:date => dt)
			end
		end
		#ボトムスを選択する
		bottoms = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,short_pants,harf_pants,short_skirt,harf_skirt).map{|p| p.attributes }
		if bottoms.length == 0 then
			puts "このひとはボトムスを持っていません"
		else
			puts "このひとはボトムスを持っています"
			t = rand(bottoms.length)
			p bottoms[t]
			puts bottoms[t]["id"]
			Recommend.create(:user_id => user_id,:cloth_id => bottoms[t]["id"],:date => dt)
		end
		#靴を選択
		shoes = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ?)",user_id,sneaker,sandal).map{|p| p.attributes }
		if shoes.length == 0 then
			puts "このひとは靴を持っていません"
		else
			puts "このひとは靴を持っています"
			t = rand(shoes.length)
			p shoes[t]
			puts shoes[t]["id"]
			Recommend.create(:user_id => user_id,:cloth_id => shoes[t]["id"],:date = dt)
		end
		#その他を選択
		hats = Clothe.where("user_id = ? AND tag_id = ?",user_id,hat)
		if hats.length == 0 then
			puts "このひとは帽子を持っていません"
		else
			puts "このひとは帽子をもっています"
			u = rand(1)
			t = rand(hats.length)
			#0だった場合は帽子あり
			if u == 0 then
				Recommend.create(:user_id => user_id,:cloth_id => hats[t]["id"],:date = dt)
			end
		end
	end
end

#15度以上20度以下洋服選択処理
def selectClothes15(user_id,dt)
	firstLayer = []
	puts "user_id:" + user_id.to_s
	firstLayer = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,harf_tshirt,long_tshirt,tunic).map{|p| p.attributes }
	p firstLayer.class
	if firstLayer.length == 0 then
		puts "この人は１層目を持っていません"
		puts firstLayer
	else
		puts "この人は１層目を持っています"
		#puts firstLayer
		#抽出した1層目の中から1つランダムで選択
		t = rand(firstLayer.length)
		p firstLayer[t]
		puts firstLayer[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => firstLayer[t]["id"],:date => dt)
		#もし選択した1層目がTシャツ（半袖）:3 またはTシャツ（長袖）:4だった場合、シャツ（長袖）:6またはチュニック:9を選択
		if firstLayer[t]["tag_id"] == 3 || firstLayer[t]["tag_id"] == 4 then
			secondlayer = Clothe.where("user_id = ? AND tag_id = ? OR tag_id =?",user_id,long_shirt,tunic).map{|p| p.attributes }
			if secondlayer.length == 0 then
				puts "この人は2層目を持っていません"
			else
				puts "この人は2層目を持っています"
				puts secondlayer
				t = rand(secondlayer.length)
				p secondlayer[t]
				puts secondlayert]["id"]
				Recommend.create(:user_id => user_id,:cloth_id => secondlayer[t]["id"],:date => dt)
				#シャツ（長袖）を選択した場合、ジャケット:11またはカーディガン:10もあり
				thirdlayer = Clothe.where("user_id = ? AND tag_id = ? OR ",user_id,cardigan,jacket).map{|p| p.attributes }
				if thirdlayer.length == 0 then
					puts "このひとは３層目を持っていません"
				else
					puts "このひとは３層目を持っています"
					u = rand(1)
					t = rand(thirdlayer.length)
					#uが0だった場合はジャケット、カーディガン有り
					if u == 0 then
						Recommend.create(:user_id => user_id,:cloth_id => thirdlayer[t]["id"],:date = dt)
					end
				end
			end
		end
		#ボトムスを選択する
		bottoms = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,long_pants,harf_pants,long_skirt,harf_skirt).map{|p| p.attributes }
		if bottoms.length == 0 then
			puts "このひとはボトムスを持っていません"
		else
			puts "このひとはボトムスを持っています"
			t = rand(bottoms.length)
			p bottoms[t]
			puts bottoms[t]["id"]
			Recommend.create(:user_id => user_id,:cloth_id => bottoms[t]["id"],:date => dt)
		end
		#靴を選択
		shoes = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,sneaker,leather_shoes,pumps).map{|p| p.attributes }
		if shoes.length == 0 then
			puts "このひとは靴を持っていません"
		else
			puts "このひとは靴を持っています"
			t = rand(shoes.length)
			p shoes[t]
			puts shoes[t]["id"]
			Recommend.create(:user_id => user_id,:cloth_id => shoes[t]["id"],:date = dt)
		end
	end
end

#Tシャツ選択処理
def selectTshirt(user_id,dt)
	t_shirts = []
	puts "user_id:" + user_id.to_s
	t_shirts = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ?)",user_id,3,4).map{|p| p.attributes }
	p t_shirts.class
	if t_shirts.length == 0 then
		puts "この人はTシャツを持っていません"
		puts t_shirts
	else
		puts "このひとはTシャツを持っています"
		#puts t_shirts
		#抽出したTシャツの中から1つランダムで選択
		t = rand(t_shirts.length)
		p t_shirts[t]
		puts t_shirts[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => t_shirts[t]["id"],:date => dt)
	end
end

#10度以下2層目,3層目選択処理
def selectSecondLayer10(user_id,dt)
	secondlayer = []
	puts "user_id:" + user_id.to_s
	secondlayer = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,6,7,8,9).map{|p| p.attributes }
	p secondlayer.class
	if secondlayer.length == 0 then
		puts "この人は２層目を持っていません"
		puts secondlayer
	else
		puts "このひとは２層目を持っています"
		#puts t_shirts
		#抽出したTシャツの中から1つランダムで選択
		t = rand(secondlayer.length)
		p secondlayer[t]
		puts secondlayer[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => secondlayer[t]["id"],:date => dt)
		#もし選択した2層目がシャツ（長袖）:6 だった場合、ジャケット:11 も有り
		if secondlayer[t]["tag_id"] == 6 then
			u = rand(1)
			#0だった場合はジャケットあり
			if u == 0 then
				thirdlayer = Clothe.where("user_id = ? AND tag_id = ?",user_id,11).map{|p| p.attributes }
				if thirdlayer.length == 0 then
					puts "この人は3層目を持っていません"
				else
					puts "この人は3層目を持っています"
					puts thirdlayer
					t = rand(thirdlayer.length)
					p thirdlayer[t]
					puts thirdlayer[t]["id"]
					Recommend.create(:user_id => user_id,:cloth_id => thirdlayer[t]["id"],:date => dt)
				end
			end
		end
	end
end


#15度以下アウター選択処理
def selectOuters15(user_id,dt)
	outers = []
	puts "user_id:" + user_id.to_s
	outers = Clothe.where("user_id = ? AND tag_id = ?",user_id,2).map{|p| p.attributes }
	p outers.class
	if outers.length == 0 then
		puts "この人はアウターを持っていません"
		puts outers
	else
		puts "このひとはアウターを持っています"
		#抽出したアウターの中から1つランダムで選択
		t = rand(outers.length)
		p outers[t]
		puts outers[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => outers[t]["id"],:date => dt)
	end
end


#10度以下アウター選択処理
def selectOuters10(user_id,dt)
	outers = []
	puts "user_id:" + user_id.to_s
	outers = Clothe.where("user_id = ? AND tag_id = ?",user_id,1).map{|p| p.attributes }
	p outers.class
	if outers.length == 0 then
		puts "この人はアウターを持っていません"
		puts outers
	else
		puts "このひとはアウターを持っています"
		#抽出したアウターの中から1つランダムで選択
		t = rand(outers.length)
		p outers[t]
		puts outers[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => outers[t]["id"],:date => dt)
	end
end

#10度以下ボトムス選択処理
def selectBottoms10(user_id,dt)
	bottoms = []
	puts "user_id:" + user_id.to_s
	bottoms = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,13,14,16,17).map{|p| p.attributes }
	p bottoms.class
	if bottoms.length == 0 then
		puts "この人はボトムスを持っていません"
		puts bottoms
	else
		puts "このひとはボトムスを持っています"
		#抽出したTシャツの中から1つランダムで選択
		t = rand(bottoms.length)
		p bottoms[t]
		puts bottoms[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => bottoms[t]["id"],:date => dt)
	end
end

#10度以下靴選択処理
def selectShoes10(user_id,dt)
	shoes = []
	puts "user_id:" + user_id.to_s
	shoes = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,30,31,35).map{|p| p.attributes }
	p shoes.class
	if shoes.length == 0 then
		puts "この人は靴を持っていません"
		puts shoes
	else
		puts "このひとは靴を持っています"
		#抽出したTシャツの中から1つランダムで選択
		t = rand(shoes.length)
		p shoes[t]
		puts shoes[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => shoes[t]["id"],:date => dt)
	end
end

#5度以下靴選択処理
def selectShoes5(user_id,dt)
	shoes = []
	puts "user_id:" + user_id.to_s
	shoes = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,30,31,33,35).map{|p| p.attributes }
	p shoes.class
	if shoes.length == 0 then
		puts "この人は靴を持っていません"
		puts shoes
	else
		puts "このひとは靴を持っています"
		#抽出したTシャツの中から1つランダムで選択
		t = rand(shoes.length)
		p shoes[t]
		puts shoes[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => shoes[t]["id"],:date => dt)
	end
end

#5度以下その他択処理
def selectOthers5(user_id,dt)
	others = []
	puts "user_id:" + user_id.to_s
	others = Clothe.where("user_id = ? AND (tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ? OR tag_id = ?)",user_id,19,21,27,28,29).map{|p| p.attributes }
	p others.class
	if others.length == 0 then
		puts "この人はその他を持っていません"
		puts others
	else
		puts "このひとはその他を持っています"
		#抽出したその他の中から1つランダムで選択
		t = rand(others.length)
		p others[t]
		puts others[t]["id"]
		Recommend.create(:user_id => user_id,:cloth_id => others[t]["id"],:date => dt)
	end
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
				selectClothes25(user_id,dt)
				
			elsif 20<=temp && temp<25 then
				puts temp
				puts ("HOT!!")
				selectClothes20(user_id,dt)

			elsif 15<=temp && temp<20 then
				puts temp
				puts ("WARM!!")
				selectClothes15(user_id,dt)
			
			elsif 10<=temp && temp<15 then
				puts temp
				puts ("FeelGood!!")
			
			elsif 5<=temp && temp<10 then
				puts temp
				puts ("cool!!")
				#Tシャツ挿入
				selectTshirt(user_id,dt)
				selectSecondLayer(user_id,dt)
				selectOuter(user_id,dt)
				selectBottoms(user_id,dt)
				
			elsif temp<5 then
				puts temp
				puts ("cold!!")
				puts "user_id:" + user_id.to_s
				selectTshirt(user_id,dt)
				selectSecondLayer(user_id,dt)
				selectOuter(user_id,dt)
				selectBottoms(user_id,dt)
				selectOthers5(user_id,dt)
			end
		#else
			#puts "当日日付が含まれていません"
		end
	end
end

