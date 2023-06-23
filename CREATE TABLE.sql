CREATE TABLE CUSTOMERS(
EmailAddress		Varchar(50)		NOT NULL ,
FiratName			Varchar	(20)	NOT NULL,
LastName			Varchar(20)		NOT NULL,
PhoneNumber			Varchar(20)		NOT NULL,

CONSTRAINT PK_Customers	PRIMARY KEY (EmailAddress),
CONSTRAINT CK_EmailAddress	CHECK (EmailAddress LIKE '%@%.%'),
)



CREATE TABLE ADDRESSES(
Country				Varchar(20)		NOT NULL,
City				Varchar(20)		NOT NULL,
Street				Varchar(40)		NOT NULL,
HomeNumber			Varchar(5)		NOT NULL,
PostleCode			VarChar(20)		NOT NULL,
Apartment			Integer			NULL,
CONSTRAINT PK_Addresse 
PRIMARY KEY (Country,City,Street,HomeNumber),

CONSTRAINT CK_Apartment	CHECK	(Apartment > 0 ),

)

CREATE TABLE ORDERS(
OrderID				Varchar(20)		NOT NULL,
DelivaryDate		DateTime		NOT NULL,
PickUp				DateTime		NOT NULL,
Weight				DEC(5,3)		NOT NULL,
Country				Varchar(20)		NOT NULL,
City				Varchar(20)		NOT NULL,
Street				Varchar(40)		NOT NULL,
HomeNumber			Varchar(5)		NOT NULL,
EmailAddress		Varchar(50)		NOT NULL,

CONSTRAINT PK_Order	PRIMARY KEY (OrderID),

CONSTRAINT fk_Addresse
FOREIGN KEY (Country,City,Street,HomeNumber)
REFERENCES ADDRESSES(Country,City,Street,HomeNumber),

CONSTRAINT fk_Customer
FOREIGN KEY (EmailAddress)
REFERENCES CUSTOMERS(EmailAddress),

CONSTRAINT CK_Weight	CHECK	(Weight > 0 ),

)


CREATE TABLE SURFBOARDS(
SurfBoardID			Varchar(20)		NOT NULL ,
SurfBoardName		Varchar(20)		NOT NULL,
FinSystem			Varchar(20)		NOT NULL,
BasePrice			Money			NOT NULL,
Length				DEC(5,3)		NOT NULL

CONSTRAINT PK_SurfBoard	PRIMARY KEY (SurfBoardID),

CONSTRAINT CK_BasePrice	CHECK	(BasePrice > 0 ),
CONSTRAINT CK_Length	CHECK	(Length	 > 0 ),
	)


	 

CREATE TABLE CUSTOMIZES(
CustomizeID			Varchar(20)		NOT NULL,
Dimensions			DEC(5,3)	    NULL,
Volume				DEC(5,3)		NULL,
Construction		Varchar(20)		NULL,
Logo				Varchar(20)		NULL,
ArtWork				Varchar(20)		NULL,
Gear				Varchar(20)		NULL,
FinPlugs			Varchar(20)		NOT NULL,
Pads				Varchar(20)		NULL,
CustomizePrice		Money			NULL,
SurfBoardID			Varchar(20)		NOT NULL,

CONSTRAINT PK_Customozes	PRIMARY KEY (SurfBoardID,CustomizeID),			

CONSTRAINT fk_SurfBoard
FOREIGN KEY (SurfBoardID)
REFERENCES SURFBOARDS(SurfBoardID),

CONSTRAINT CK_CustomizePrice	CHECK	(CustomizePrice	 > 0 ),

)


CREATE TABLE CREDITCARDS(
CardNumber		Varchar(16)			NOT NULL,
CompanyCard		Varchar(40)			NOT NULL,
ExpirationMonth	Tinyint				NOT NULL,
ExpirationYear	Integer				NOT NULL,
CVV				Varchar(4)			NOT NULL,
OwnerID			Varchar(20)			NOT NULL,
OrderID			Varchar(20)			NOT NULL,

CONSTRAINT PK_CreditCard	PRIMARY KEY (CardNumber),

CONSTRAINT fk_Order
FOREIGN KEY (OrderID)
REFERENCES ORDERS(OrderID),

CONSTRAINT CK_CardNumber	CHECK	(CardNumber	  LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
CONSTRAINT CK_ExpirationMonth	CHECK	(ExpirationMonth BETWEEN 1 and 12),
CONSTRAINT CK_ExpirationDate	CHECK	(ExpirationYear > (year(getdate())) or(ExpirationYear = (year(getdate())) and ExpirationMonth >= cast((month(getdate()) ) AS Integer)) ), 

)

CREATE TABLE BELONGS(

Country				Varchar(20)		NOT NULL,
City				Varchar(20)		NOT NULL,
Street				Varchar(40)		NOT NULL,
HomeNumber			Varchar(5)		NOT NULL,
EmailAddress		Varchar(50)		NOT NULL,

CONSTRAINT PK_Belongs	PRIMARY KEY(Country,City,Street,HomeNumber,EmailAddress),

CONSTRAINT fk_Addresse1
FOREIGN KEY (Country,City,Street,HomeNumber)
REFERENCES ADDRESSES(Country,City,Street,HomeNumber),

CONSTRAINT fk_Customer1
FOREIGN KEY (EmailAddress)
REFERENCES CUSTOMERS(EmailAddress),

)


