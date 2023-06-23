--Country
CREATE TABLE COUNTRIES(
Country		Varchar(20)			PRIMARY KEY
)

INSERT INTO COUNTRIES VALUES
('New York'),('kentucky'),('Pensilvania'),('California'),('Alska'),('Delaware'),('Kansas'),('Oragon'),
('Washington'),('Navada'),('Arizona'),('new Mexico'),('New Jersey'),('Ohio'),('North Carolina'),('South Carolina'),
('Vermont'),('Oklahoma'),('Georgia'),('Virgina'),('Boltimore'),('MaryLand'),('Minesota'),('Nebraska'),('Texas'),('North Dakota'),('South Dakota')

ALTER TABLE	ADDRESSES
ADD CONSTRAINT	FK_Countries FOREIGN KEY (Country) REFERENCES COUNTRIES(Country)

--City
CREATE TABLE CITIES(
City		Varchar(20)			PRIMARY KEY
)

INSERT INTO CITIES VALUES
('Montgomery'),('Juneau'),('Phoenix'),('Little Rock'),('Sacramento'),('Denver'),('Hartford'),('Dover'),('Tallahassee'),('Atlanta'),
('Honolulu'),('Boise'),('Springfield'),('Indianapolis'),('Des Moines'),('Topeka'),('Frankfort'),('Baton Rouge'),('Augusta'),
('Annapolis'),('Boston'),('Lansing'),('St. Paul'),('Jackson'),('Jefferson City'),('Helena'),(' Lincoln'),('Carson City'),('Concord'),('Trenton'),
('Santa Fe'),('Albany'),('Raleigh'),('Bismarck'),('Columbus'),('Oklahoma City'),('Salem'),('Harrisburg'),('Providence'),('Columbia'),('Pierre'),
('Nashville'),('Austin'),('Salt Lake City'),('Montpelier'),('Richmond'),('Olympia'),('Charleston'),('Madison'),('Cheyenne')

ALTER TABLE	ADDRESSES
ADD CONSTRAINT	FK_Cities FOREIGN KEY (City) REFERENCES CITIES(City)

--SurfBoardName
CREATE TABLE SURFBOARDNAMES(
SurfBoardName		Varchar(20)			PRIMARY KEY
)

INSERT INTO SURFBOARDNAMES VALUES
('Miso'),('New Traveler'), ('The Keg'),('Shiv'),('419Fish'),('Dwart'),('Hatchet'),('Dozer'),('1984'),('Hustler'),('Moby Fish'),('Fish Quatro'),('Smoothie'),('Heckler'),
('Twin Fin'),('Neil'),('Dwart Too'), ('Chupacabra'),('Black Bird'),('Enough Said'),('SD'),('Yes Thanks'),('Model 8'),('Barking Spider'),('Sista Brotha'),('The Blade'),('Slayer 1'),('Mi Amigo'),('Slayer 2'),('The Rooster'),
('Desert Island'),('Gun'),('El Dorado'),('Utility')


ALTER TABLE	SURFBOARDS
ADD CONSTRAINT	FK_SurfBoardNames FOREIGN KEY (SurfBoardName) REFERENCES SURFBOARDNAMES(SurfBoardName)

--Length
CREATE TABLE LENGTHS(
Length		DEC(5,3)			PRIMARY KEY
)

INSERT INTO LENGTHS VALUES
(5.1),(5.2),(5.3),(5.4),(5.5),(5.6),
(5.7),(5.8),(5.9),(6),(6.1),(6.2)


ALTER TABLE	SURFBOARDS
ADD CONSTRAINT	FK_Lengths FOREIGN KEY (Length) REFERENCES LENGTHS(Length)

--FinSystem
CREATE TABLE FINSYSTEMS(
FinSystem		Varchar(20)			PRIMARY KEY
)

INSERT INTO FINSYSTEMS VALUES
('Futures'),('FCS X2'),('FCS Fusion'),('FCS 2')

ALTER TABLE	SURFBOARDS
ADD CONSTRAINT	FK_FinSystems FOREIGN KEY (FinSystem) REFERENCES FINSYSTEMS(FinSystem)


--FinPlugs
CREATE TABLE FINPLUGS(
FinPlugs		Varchar(20)		PRIMARY KEY
)

INSERT INTO FINPLUGS VALUES
('Thruster'),('Quad'),('5 Plugs')

ALTER TABLE CUSTOMIZES
ADD CONSTRAINT	FK_FinPlugs FOREIGN KEY (FinPlugs)	REFERENCES FINPLUGS(FinPlugs)

--CompanyCard
CREATE TABLE COMPANYCARDS(
CompanyCard		Varchar(40)		PRIMARY KEY
)

INSERT INTO COMPANYCARDS VALUES
('Visa'),('MasterCard'),('American Express'),('Discovery')

ALTER TABLE CREDITCARDS 
ADD CONSTRAINT	FK_CompanyCard	FOREIGN KEY (CompanyCard)	REFERENCES COMPANYCARDS(CompanyCard)
