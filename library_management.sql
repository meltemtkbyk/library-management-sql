-- 1. Veritabanını oluştur
CREATE DATABASE IF NOT EXISTS END106;
USE END106;
-- 2.Tablolari olustur
CREATE TABLE IF NOT EXISTS Yazarlar (
    YazarID INT PRIMARY KEY,
    Ad VARCHAR(50),
    Soyad VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Kitaplar (
    KitapID INT PRIMARY KEY,
    Ad VARCHAR(100),
    Basim INT,
    Kategori VARCHAR(50),
    YazarID INT,
    Stok INT DEFAULT 1,
    FOREIGN KEY (YazarID) REFERENCES Yazarlar(YazarID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Uyeler (
    UyeID INT PRIMARY KEY,
    Ad VARCHAR(50),
    Soyad VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Kayit DATE
);



CREATE TABLE IF NOT EXISTS Odunc (
    OduncID INT PRIMARY KEY,
    UyeID INT,
    KitapID INT,
    Tarih DATE,
    IadeTarih DATE NULL,
    Durum VARCHAR(50),
	CONSTRAINT CHK_Durum CHECK (Durum IN ('Gecikti', 'Tamamlandi', 'Iptal')),
    FOREIGN KEY (UyeID) REFERENCES Uyeler(UyeID) ON DELETE CASCADE,
    FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID) ON DELETE CASCADE

);

DROP TABLE IF EXISTS Rezervasyon;

CREATE TABLE IF NOT EXISTS Rezervasyon (
    RezID INT PRIMARY KEY,
    UyeID INT,
    KitapID INT,
    Tarih DATE,
    FOREIGN KEY (UyeID) REFERENCES Uyeler(UyeID) ON DELETE CASCADE,
    FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Ceza (
    OduncID INT PRIMARY KEY,
    UyeID INT,
    Tutar INT,
    FOREIGN KEY (UyeID) REFERENCES Uyeler(UyeID) ON DELETE CASCADE
); 

-- 3. Örnek veri ekleme
INSERT IGNORE INTO Yazarlar (YazarID, Ad, Soyad) VALUES 
(100,'Ivan','Goncharov'), 
(101,'Martin','Heidegger'), 
(102,'Suzanne','Collins'), 
(103,'Sabahattin','Ali'), 
(104,'Halide Edip','Adivar'),
(105,'Carl','Sagan'),
(106,'Stephen','King'),
(107,'JRR','Tolkien'),
(108,'Sylvia','Plath'),
(109,'Dan','Brown');

INSERT IGNORE INTO Kitaplar (KitapID, YazarID, Ad, Basim, Kategori, Stok) VALUES 
(10, 100, 'Oblomov', 1859, 'Kurgu', 1),
(11, 101, 'Varlik ve Zaman', 1927, 'Felsefe', 1),
(12, 102, 'Açlik Oyunlari', 2008, 'Distopya', 1),
(13, 103, 'İçimizdeki Şeytan', 1940, 'Kurgu', 1),
(14, 104, 'Ateşten Gömlek', 1922, 'Kurgu', 1),
(15, 105, 'Kozmos', 1980, 'Bilim', 1),
(16, 106, 'O', 1986, 'Korku', 1),
(17, 107, 'Yüzüklerin Efendisi', 1957, 'Fantezi', 1),
(18, 108, 'Ariel', 1965, 'Şiir', 1),
(19, 109, 'Kayip Sembol', 2009, 'Gerilim', 1),
(20,109,'Cehennem',2013,'Gerilim',1);


INSERT IGNORE INTO Uyeler (UyeID, Ad, Soyad, Email, Kayit) VALUES 
(1, 'Elçin', 'Erkol', 'erkol@gmail.com', '2024-02-02'),
(2, 'Deniz', 'Geceler', 'dnzg@gmail.com', '2023-11-14'),
(3, 'Meltem', 'Tekbiyik', 'mltm@gmail.com', '2024-04-25'),
(4, 'Ela', 'Zarali', 'zarali@gmail.com', '2024-08-16');



INSERT IGNORE INTO Odunc (OduncID, UyeID, KitapID, Tarih, IadeTarih, Durum) VALUES
(20, 3, 15, '2024-04-26', NULL, 'Gecikti'),
(21, 1, 11, '2024-03-01', '2024-03-17', 'Tamamlandi'),
(22, 1, 16, '2024-03-18', NULL, 'Gecikti'),
(23, 2, 18, NULL, NULL, 'Iptal'),
(24, 2, 12, NULL, NULL, 'Iptal'),
(25, 4, 11, '2024-08-17', '2024-09-20', 'Gecikti'),
(26, 4, 13, '2024-09-30', '2024-12-13', 'Gecikti'),
(27, 3, 10, '2025-02-27', NULL, 'Gecikti'),
(28, 4, 19, '2025-02-21', NULL, 'Bekliyor');

INSERT IGNORE INTO Rezervasyon (RezID, UyeID, KitapID, Tarih) VALUES
(30, 3, 15, '2024-04-26'),
(31, 1, 11, '2024-03-01'),
(32, 1, 16, '2024-03-18'),
(33, 2, 18, '2024-06-09'),
(34, 2, 12, '2024-06-10'),
(35, 4, 11, '2024-08-17'),
(36, 4, 13, '2024-09-30'),
(37, 3, 10, '2025-02-27'),
(38, 4, 19, '2025-02-21');


INSERT IGNORE INTO Ceza (OduncID, UyeID, Tutar) VALUES 
(20, 3, 15050),
(22, 1, 17050),
(25, 4, 9400),
(26, 4, 7200);-- 31.maddede ceza tutarlari hesaplandi

-- 4. Üyeleri listeleme
SELECT * FROM Uyeler;

-- 5. Üye bilgilerini getirme
SELECT UyeID, Ad, Soyad, Email, Kayit FROM Uyeler;

-- 6.Belirli bir üyenin odunc aldigi kitaplar listeleme
SELECT o.OduncID, u.Ad AS UyeAd, u.Soyad AS UyeSoyad, k.Ad AS KitapAd, o.Tarih, o.IadeTarih, o.Durum
FROM Odunc o
JOIN Uyeler u ON o.UyeID = u.UyeID
JOIN Kitaplar k ON o.KitapID = k.KitapID
WHERE u.UyeID = 1; -- 1.Üyeyi yazdik

-- 7.En cok kitap alan üyeleri sirala
SELECT 
    u.UyeID, 
    u.Ad, 
    u.Soyad, 
    COUNT(o.OduncID) AS ToplamOduncKitapSayisi
FROM 
    Uyeler u
JOIN 
    Odunc o ON u.UyeID = o.UyeID
JOIN 
    Kitaplar k ON o.KitapID = k.KitapID -- Kitaplar tablosu ile eşleştir
WHERE 
    o.Durum IN ('Tamamlandi', 'Gecikti') -- Sadece tamamlanmış veya gecikmiş ödünçleri say
GROUP BY 
    u.UyeID, u.Ad, u.Soyad
ORDER BY 
    ToplamOduncKitapSayisi DESC;
    
-- 8.Gecikme cezasi olan üyeleri listeleme
 SELECT DISTINCT
    u.UyeID, 
    u.Ad, 
    u.Soyad, 
    u.Email, 
    k.Ad AS KitapAd, 
    c.Tutar AS CezaTutari
FROM 
    Uyeler u
JOIN 
    Ceza c ON u.UyeID = c.UyeID
JOIN 
    Odunc o ON c.OduncID = o.OduncID
JOIN 
    Kitaplar k ON o.KitapID = k.KitapID
ORDER BY 
    c.Tutar DESC;

-- 9.En cok gecikme yasayan uyeler
SELECT 
    u.UyeID, 
    u.Ad, 
    u.Soyad, 
    COUNT(o.OduncID) AS ToplamGecikmeSayisi
FROM 
    Uyeler u
JOIN 
    Odunc o ON u.UyeID = o.UyeID
WHERE 
    o.Durum = 'Gecikti' -- Sadece gecikme durumundaki ödünçleri say
GROUP BY 
    u.UyeID, u.Ad, u.Soyad
ORDER BY 
    ToplamGecikmeSayisi DESC;
    
-- 10.Belirli bir uyenin en son aldigi kitabi getirme
SELECT 
    u.UyeID, 
    u.Ad AS UyeAd, 
    u.Soyad AS UyeSoyad, 
    k.Ad AS KitapAd, 
    o.Tarih AS OduncTarihi
FROM 
    Uyeler u
JOIN 
    Odunc o ON u.UyeID = o.UyeID
JOIN 
    Kitaplar k ON o.KitapID = k.KitapID
WHERE 
    u.UyeID = 3 -- Meltem Tekbiyik icin sorguland
ORDER BY 
    o.Tarih DESC 
LIMIT 1; -- Sadece 1 kayit getirmesi icin kullanildi

-- 11.Son 1 yilda kutuphaneye kayit olan uye sayisini listeleme
SELECT 
    UyeID, 
    Ad, 
    Soyad, 
    Email, 
    Kayit
FROM 
    Uyeler
WHERE 
    Kayit >= DATE_SUB(SYSDATE(), INTERVAL 1 YEAR)
ORDER BY 
    Kayit DESC;

-- 12.Kutuphane koleksiyonundaki kitaplarin ortalama yasini hesaplama
SELECT 
    Ad, 
    Basim, 
    YEAR(SYSDATE()) - Basim AS KitapYasi
FROM 
    Kitaplar
ORDER BY 
    KitapYasi DESC;
    
-- 13.En cok odunc alinan kitaplari listele
SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    COUNT(o.OduncID) AS ToplamOduncSayisi
FROM 
    Kitaplar k
JOIN 
    Odunc o ON k.KitapID = o.KitapID
WHERE 
    o.Durum IN ('Tamamlandi', 'Gecikti') -- Sadece tamamlanmış veya gecikmiş ödünçleri say
GROUP BY 
    k.KitapID, k.Ad
ORDER BY 
    ToplamOduncSayisi DESC;    
    
-- 14.Belirli bir yazarin kitaplarini listeleme
SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    k.Basim, 
    k.Kategori, 
    k.Stok
FROM 
    Kitaplar k
WHERE 
    k.YazarID = 102; -- Suzanne Collins icin listeleme
    
-- 15.Belirli bir kategoriye ait kitaplari listeleme
SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    k.Basim, 
    k.Kategori, 
    k.Stok,
    y.Ad AS YazarAd, 
    y.Soyad AS YazarSoyad
FROM 
    Kitaplar k
JOIN 
    Yazarlar y ON k.YazarID = y.YazarID
WHERE 
    k.Kategori = 'Kurgu'; -- Kurgu kategorisi icin listelendi



-- 16.Stokta olmayan kitaplari listeleme
UPDATE Kitaplar k
JOIN Odunc o ON k.KitapID = o.KitapID
SET k.Stok = k.Stok - 1
WHERE o.Durum IN ('Tamamlandi', 'Gecikti') 
AND k.Stok > 0; 

SELECT 
    KitapID, 
    Ad AS KitapAd, 
    Basim, 
    Kategori, 
    Stok
FROM 
    Kitaplar
WHERE 
    Stok = 0;  

-- 17. En popüler kategoriye ait kitapları listele
SELECT Ad, Kategori
FROM Kitaplar
WHERE Kategori = (
    SELECT Kategori
    FROM Kitaplar
    JOIN Odunc ON Kitaplar.KitapID = Odunc.KitapID
    GROUP BY Kategori
    ORDER BY COUNT(Odunc.KitapID) DESC
    LIMIT 1
);
-- 18. Son 1 yılda en çok ödünç alınan kitapları listeleme.
 SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    COUNT(o.OduncID) AS ToplamOduncSayisi
FROM 
    Kitaplar k
join
    Odunc o ON k.KitapID = o.KitapID
WHERE 
    o.Tarih >= DATE_SUB(sysdate(), INTERVAL 1 YEAR) 
GROUP BY 
    k.KitapID, k.Ad
ORDER BY 
    ToplamOduncSayisi DESC; 

-- 19. Kütüphane envanterinde kaç farklı kategori olduğunu belirleme
SELECT COUNT(DISTINCT Kategori) AS FarkliKategoriSayisi
FROM Kitaplar;

-- 20. Yeni yazar ekleyebilme
INSERT IGNORE INTO Yazarlar(YazarID,Ad,Soyad) VALUES
(110,'Tess','Gerritsen');

-- 21 En çok kitap yazan yazarları sıralama.
SELECT 
    y.YazarID, 
    y.Ad AS YazarAd, 
    y.Soyad AS YazarSoyad, 
    COUNT(k.KitapID) AS KitapSayisi
FROM 
    Yazarlar y
JOIN 
    Kitaplar k ON y.YazarID = k.YazarID
GROUP BY 
    y.YazarID, y.Ad, y.Soyad
ORDER BY 
    KitapSayisi DESC;
    
-- 22. Belirli bir yazara ait kitapları listeleme
SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    k.Basim, 
    k.Kategori, 
    y.Ad AS YazarAd, 
    y.Soyad AS YazarSoyad
FROM 
    Kitaplar k
JOIN 
    Yazarlar y ON k.YazarID = y.YazarID
WHERE 
    y.YazarID = 108; -- Sylvia Plath için listeleme
    
-- 23.Kitaplari en cok odunc alinan yazarlari listeleme
SELECT 
    y.YazarID, 
    y.Ad AS YazarAd, 
    y.Soyad AS YazarSoyad, 
    COUNT(o.OduncID) AS ToplamOduncSayisi
FROM 
    Yazarlar y
JOIN 
    Kitaplar k ON y.YazarID = k.YazarID
JOIN 
    Odunc o ON k.KitapID = o.KitapID
WHERE 
    o.Durum IN ('Tamamlandi', 'Gecikti') -- Sadece tamamlanmış veya gecikmiş ödünçleri say
GROUP BY 
    y.YazarID, y.Ad, y.Soyad
ORDER BY 
    ToplamOduncSayisi DESC;
    
-- 24.Belirli bir yazarin kitaplarini ve kitaplarinin ödünc alma sayilarini listeleme
SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    COUNT(o.OduncID) AS OduncAlinmaSayisi
FROM 
    Kitaplar k
JOIN 
    Odunc o ON k.KitapID = o.KitapID
JOIN 
    Yazarlar y ON k.YazarID = y.YazarID
WHERE 
    y.YazarID = 103 -- Sabahattin Ali icin listeleme
    AND o.Durum IN ('Tamamlandi', 'Gecikti') 
GROUP BY 
    k.KitapID, k.Ad
ORDER BY 
    OduncAlinmaSayisi DESC;

-- 24.Belirli bir yazarin en cok odunc alinan kitabini belirleme
SELECT 
    k.KitapID, 
    k.Ad AS KitapAd, 
    COUNT(o.OduncID) AS ToplamOduncSayisi
FROM 
    Kitaplar k
JOIN 
    Odunc o ON k.KitapID = o.KitapID
JOIN 
    Yazarlar y ON k.YazarID = y.YazarID
WHERE 
    y.YazarID = 101 -- Martin Heidegger icin listeleme
    AND o.Durum IN ('Tamamlandi', 'Gecikti') 
GROUP BY 
    k.KitapID, k.Ad
ORDER BY 
    ToplamOduncSayisi DESC
LIMIT 1; -- Sadece 1 deger getirmesi icin ekledik

-- 25.Belirli bir üyenin gecmis odunc alma islemlerini listeleme
SELECT 
    o.OduncID, 
    u.Ad AS UyeAd, 
    u.Soyad AS UyeSoyad, 
    k.Ad AS KitapAd, 
    o.Tarih AS OduncTarihi, 
    o.IadeTarih AS IadeTarihi, 
    o.Durum
FROM 
    Odunc o
JOIN 
    Uyeler u ON o.UyeID = u.UyeID
JOIN 
    Kitaplar k ON o.KitapID = k.KitapID
WHERE 
    u.UyeID = 2; -- Deniz Geceler icin listeleme
    
-- 26.Odunc alma ve iade tarihine gore en uzun süre kitap tutan uyeleri listeleme
SELECT  
    u.UyeID, 
    u.Ad AS UyeAd, 
    u.Soyad AS UyeSoyad, 
    k.Ad AS KitapAd, 
    o.Tarih AS OduncTarihi, 
    o.IadeTarih AS IadeTarihi, 
    DATEDIFF(o.IadeTarih, o.Tarih) AS KitapTutmaSuresiGun
FROM 
    Odunc o
JOIN 
    Uyeler u ON o.UyeID = u.UyeID
JOIN 
    Kitaplar k ON o.KitapID = k.KitapID
WHERE 
    o.IadeTarih IS NOT NULL -- Sadece iade edilmiş kitapları listele
ORDER BY 
    KitapTutmaSuresiGun DESC;
    
-- 27.Rezervasyon yapilan ancak odunc alinmayan kitaplari listeleme
SELECT 
    o.OduncID, 
    o.UyeID, 
    o.KitapID, 
    k.Ad AS KitapAd,
    u.Ad AS UyeAd,
    u.Soyad AS UyeSoyad
FROM 
    Odunc o
JOIN 
    Kitaplar k ON o.KitapID = k.KitapID
JOIN 
    Uyeler u ON o.UyeID = u.UyeID
WHERE 
    o.Durum = 'Iptal'; -- En basta durumda iptal olanlari rezervasyon yapilan fakat alinmayan kitaplar olarak kurmuştuk
    
-- 28.Kitap rezervasyonlarini yönetme
SELECT 
    r.RezID, 
    r.UyeID, 
    r.KitapID, 
    r.Tarih AS RezervasyonTarihi, 
    k.Ad AS KitapAd, 
    u.Ad AS UyeAd, 
    u.Soyad AS UyeSoyad
FROM 
    Rezervasyon r
JOIN 
    Kitaplar k ON r.KitapID = k.KitapID
JOIN 
    Uyeler u ON r.UyeID = u.UyeID
WHERE 
    r.UyeID = 4; -- Ela Zarali icin sorgulama yapildi
    
-- 29.Rezervasyon süresi dolmak uzere olan kitaplari listeleme
SELECT 
    r.RezID, 
    r.UyeID, 
    r.KitapID, 
    r.Tarih AS RezervasyonTarihi, 
    DATEDIFF(SYSDATE(), r.Tarih) AS GecenGunSayisi, 
    k.Ad AS KitapAd, 
    u.Ad AS UyeAd, 
    u.Soyad AS UyeSoyad,
    CASE 
        WHEN DATEDIFF(SYSDATE(), r.Tarih) BETWEEN 28 AND 29 THEN 'Rezervasyon Dolmak Üzere'
        WHEN DATEDIFF(SYSDATE(), r.Tarih) >= 30 THEN 'Rezervasyon Süresi Doldu'
        ELSE 'Rezervasyon Aktif'
    END AS RezervasyonDurumu
FROM 
    Rezervasyon r
JOIN Kitaplar k ON r.KitapID = k.KitapID
JOIN Uyeler u ON r.UyeID = u.UyeID
WHERE 
    DATEDIFF(SYSDATE(), r.Tarih) >= 28;
-- Basta belirledigimiz kisit rezervasyon süresi 28 günü asinca dolmak üzere uyarisi vermelidir fakat rezervasyon süresi 30 gunu gecemez gectigi anda gecikti olarak alinir

-- 30.Geciken kitaplar ve gecikme cezalarini listeleme
SELECT 
    o.OduncID,
    o.UyeID,
    o.KitapID,
    k.Ad,
    o.Tarih AS OduncTarihi,
    DATE_ADD(o.Tarih, INTERVAL 30 DAY) AS SonTarih, -- 30 gün üyenin kitabi tutma hakki vardir
    DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) AS GecikmeGunu,
    DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) * 50 AS GecikmeCezasi -- 30 gün sonunda gecen her gün icin uye gunluk 50 tl ödemelidir
FROM 
    Odunc o
JOIN
	Kitaplar k ON o.KitapID = k.KitapID
WHERE 
    DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) > 0; -- Sadece gecikmisleri listeler
    
-- 31.Gecikme cezalarinin toplam tutari
SELECT 
    SUM(DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) * 50) AS ToplamGecikmeCezasi
FROM 
    Odunc o
WHERE 
    DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) > 0;
    
-- 1.Ek Sorgumuz:Iki veya daha fazla kez rezervasyon yaptiran fakat almayan kullanicilari listeleme:Bu kullanicilara bir daha kitap verilmez
SELECT 
    o.UyeID,
    u.Ad,
    u.Soyad,
    COUNT(o.OduncID) AS IptalSayisi
FROM 
    Odunc o
JOIN
Uyeler u ON o.UyeID = u.UyeID
WHERE 
    o.Durum = 'Iptal'
GROUP BY 
    o.UyeID
HAVING 
    COUNT(o.OduncID) >= 2; 

-- 2.Ek Sorgumuz:Gecikme 300 günü asan uyeleri belirleme:Bu kullanicilara da bir daha kitap verilmez
SELECT 
    o.OduncID,
    o.UyeID,
    o.KitapID,
    u.Ad,
    o.Tarih AS OduncTarihi,
    DATE_ADD(o.Tarih, INTERVAL 30 DAY) AS SonTarih, -- Ödünç tarihine 30 gün ekle
    DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) AS GecikmeGunu -- Bugün ile son tarih arasındaki fark
FROM 
    Odunc o
JOIN
Uyeler u ON o.UyeID = u.UyeID

WHERE 
    DATEDIFF(SYSDATE(), DATE_ADD(o.Tarih, INTERVAL 30 DAY)) >= 300; -- Fark 300 veya daha fazla olanları bul

