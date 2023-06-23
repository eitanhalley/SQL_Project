alter table customizes
ADD OrderID Varchar(20)	NOT NULL

ALTER TABLE customizes
ADD CONSTRAINT FK_OrderID1
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);


alter table surfboards
ADD OrderID Varchar(20)	NOT NULL

ALTER TABLE surfboards
ADD CONSTRAINT FK_OrderID
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

ALTER TABLE customizes
ADD QuantityCustomize int 



alter table orders
ADD CardNumber	Varchar(16)	NOT NULL

ALTER TABLE orders
ADD CONSTRAINT FK_CardNumber
FOREIGN KEY (CardNumber) REFERENCES Creditcards(CardNumber);