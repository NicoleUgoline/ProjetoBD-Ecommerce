-- Criar tabela Cliente
CREATE TABLE cliente (
	idClient serial PRIMARY KEY,
	Fname varchar(10), 
	Minit char(3),
	Lname varchar(20),
	CPF char(11) NOT NULL,
	Address varchar(255),
	CONSTRAINT unique_cpf_client UNIQUE (CPF)	
);

-- Ajustar a sequência da coluna idClient tabela Cliente
SELECT setval('cliente_idClient_seq', 1);

-- Criar tabela de junção entre cliente e payment_method
CREATE TABLE client_payment_method (
    idClient int REFERENCES cliente(idClient),
    idPaymentMethod int REFERENCES payment_method(idPaymentMethod),
    PRIMARY KEY (idClient, idPaymentMethod)
);

CREATE TYPE product_category AS ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis');

-- Criar tabela Produto
CREATE TABLE product (
	idProduct serial PRIMARY KEY,
	Pname varchar(30) NOT NULL, 
	classification_kids bool DEFAULT false,
	category product_category NOT NULL,
	avaliacao numeric(5,2) DEFAULT 0,
	dimensions varchar(10)
);

CREATE TYPE payment_type AS ENUM('Boleto', 'Cartão', 'Dois cartões');

-- Criar tabela Pagamentos
CREATE TABLE payments (
	idPayment serial PRIMARY KEY,
	idClient int REFERENCES cliente(idClient),
	typePayment payment_type,
	limitAvailable float
);

CREATE TYPE pedido_status AS ENUM('Cancelado', 'Confirmado', 'Em processamento'); 

-- Criar tabela Pedido 
CREATE TABLE pedido (
	idPedido serial PRIMARY KEY,
	idPedidoClient int REFERENCES cliente(idClient) ON UPDATE CASCADE ON DELETE SET NULL,
	pedidoStatus pedido_status DEFAULT 'Em processamento',
	pedidoDescription varchar(255),
	sendValue float DEFAULT 10,	
	paymentCash bool DEFAULT false
	
);

-- Criar tabela Estoque
CREATE TABLE productStorage (
	idProdStorage serial PRIMARY KEY,
	storageLocation varchar(255),
	quantity int DEFAULT 0
);

-- Criar tabela Entidade para redução de redundânica: socialName e CNPJ
CREATE TABLE entity (
	entity_id serial PRIMARY KEY,
	socialName varchar(255) NOT NULL,
	CNPJ char(15) UNIQUE NOT NULL
);

-- Criar tabela Fornecedor
CREATE TABLE supplier (
	idSupplier serial PRIMARY KEY,
	entity_id int REFERENCES entity(entity_id),
	contact char(11) NOT NULL
);

-- Criar tabela Vendedor
CREATE TABLE seller (
	idSeller serial PRIMARY KEY,
	entity_id int REFERENCES entity(entity_id),
	abstName varchar(255),
	CPF char(11),
	location varchar(255),
	contact char(11) NOT NULL,
	CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Criar tabela Produtos vendedor (terceiro)
CREATE TABLE productSeller(
	idPseller int,
	idPproduct int,
	prodQuantity int DEFAULT 1,
	PRIMARY KEY (idPseller, idPproduct),
	CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
	CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

CREATE TYPE po_status AS ENUM('Disponível', 'Sem estoque');

-- Criar tabela productOrder
CREATE TABLE productOrder(
	idPOproduct int,
	idPOorder int,
	poQuantity int DEFAULT 1,
	poStatus po_status DEFAULT 'Disponível',
	PRIMARY KEY (idPOproduct, idPOorder),
	CONSTRAINT fk_productorder_seller FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
	CONSTRAINT fk_productorder_product FOREIGN KEY (idPOorder) REFERENCES pedido(idPedido)
);

-- Crair tabela storageLocation
CREATE TABLE storageLocation (
	idLproduct int,
	idLstorage int,
	localizacao varchar(255) NOT NULL,
	PRIMARY KEY (idLproduct, idLstorage),
	CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
	CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);

-- Inserindo Valores
-- idClient, Fname, Minit, Lname, CPF, Address
INSERT INTO cliente (idClient, Fname, Minit, Lname, CPF, Address)
VALUES 
    (1, 'Maria', 'M', 'Silva', '12346789', 'Rua Silva de Prata 29, Caragola - Cidade das Flores'),
    (2, 'Matheus', 'O', 'Pimentel', '987654321', 'Rua Almeida 289, Centro - Cidade das Flores'),
	(3, 'Ricardo', 'F', 'Silva', '45678913', 'Avenida Almeida Vinha 1009, Centro - Cidade das Flores'),
	(4, 'Julia', 'S', 'França', '789123456', 'Rua Lareijas 861, Centro - Cidade das Flores'),
	(5, 'Roberta', 'G', 'Assis', '98745631', 'Avenida Koller 19, Centro - Cidade das Flores'),
	(6, 'Isabela', 'M', 'Cruz', '654789123', 'Rua Almeida das Flores 28, Centro - Cidade das Flores');

-- idProduct, Pname, classification_kids, category('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis'), avaliacao, dimensions
INSERT INTO product (idProduct, Pname, classification_kids, category, avaliacao, dimensions)
VALUES
	(1, 'Fone de ouvido', false, 'Eletrônico', 4.00, NULL),
	(2, 'Microfone Vedo - Youtuber', false, 'Eletrônico', 4.00, NULL),
	(3, 'Body Carters', true, 'Vestimenta', 5.00, NULL),
	(4, 'Barbie Elsa', true, 'Brinquedos', 3.00, NULL),
	(5, 'Sofá retrátil', false, 'Móveis', 3.00, '3x57x80'),
	(6, 'Farina de arroz', false, 'Alimentos', 2.00, NULL),
	(7,'Fire Stick Amazon', false, 'Eletrônico', 3.00, NULL);

-- idPedido, idPedidoClient, pedidoStatus, pedidoDescription, sendValue, paymentCash
INSERT INTO pedido (idPedidoClient, pedidoStatus, pedidoDescription, sendValue, paymentCash)
VALUES
	(1, 'Em processamento', 'Compra via aplicativo', 0.00, true),
	(2, 'Em processamento', 'Compra via aplicativo', 50.00, false),
	(3, 'Confirmado', NULL, 0.00, true),
	(4, 'Em processamento', 'Compra via web site', 150.00, false);
	
-- idPOproduct, idPOorder, poQuantity, poStatus
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
VALUES 
	(1, 4, 2, NULL),
	(2, 4, 1, NULL),
	(3, 3, 1, NULL); 

-- storageLocation, quantity
INSERT INTO productStorage (storageLocation, quantity)
VALUES
	('Rio de Janeiro', 1000),
	('Rio de Janeiro', 500),
	('São Paulo', 10),
	('São Paulo', 100), 
	('São Paulo', 10),
	('Brasília', 60);

-- idLproduct, idLstorage, localizacao
INSERT INTO storageLocation (idLproduct, idLstorage, localizacao)
VALUES
	(1, 2, 'RJ'),
	(2, 3, 'GO');

-- Inserir valores na tabela entity
INSERT INTO entity (socialName, CNPJ)
VALUES
    ('Almeida e filhos', '123456789123456'),
    ('Eletrônicos Silva', '854519649143457'),
    ('Eletrônico Valma', '934567893934695');

-- Inserir valores na tabela "supplier" com referência aos IDs da tabela "entity"
INSERT INTO supplier (entity_id, contact)
VALUES
    (1, '21985474'), -- Referência ao fornecedor 'Almeida e filhos' na tabela "entity"
    (2, '21985484'), -- Referência ao fornecedor 'Eletrônicos Silva' na tabela "entity"
    (3, '21975474'); -- Referência ao fornecedor 'Eletrônico Valma' na tabela "entity"

-- Remover a restrição NOT NULL da coluna CNPJ na tabela entity
ALTER TABLE entity
ALTER COLUMN CNPJ DROP NOT NULL;

-- Inserir valores na tabela entity
INSERT INTO entity (socialName, CNPJ)
VALUES
    ('Tech eletronics', '123456789456321'),
    ('Botique Durgas', NULL),
    ('Kids World', '456789123654485');

-- idSeller, entity_id, abstName, CPF, location, contact
INSERT INTO seller (entity_id, abstName, CPF, location, contact)
VALUES
	(6, NULL, NULL, 'Rio de Janeiro', 219946287), -- Referência ao 'Tech eletronics' na tabela "entity"
	(7, NULL, 123456783, 'Rio de Janeiro', 219567895), -- Referência ao 'Botique Durgas' na tabela "entity"
	(8, NULL, NULL, 'São Paulo', 1198657484); -- Referência ao 'Kids World' na tabela "entity" 

SELECT idseller FROM seller;

-- idPseller. idPproduct, prodQuantity
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity)
VALUES
	(4, 6, 80),
	(5, 5, 10);
	
-- Recuperação simples com instrução SELECT
SELECT * FROM cliente;

-- Filtros com WHERE Statement: recuperar todos os produtos da categoria "Eletrônico"
SELECT * FROM product WHERE category = 'Eletrônico';

-- Calculando a média de avaliação para produtos na categoria 'Eletrônico'
SELECT category, AVG(avaliacao) AS media_avaliacao
FROM product
WHERE category = 'Eletrônico'
GROUP BY category;

-- Recuperar produtos em ordem descrescente de avaliação
SELECT * FROM product ORDER BY avaliacao DESC;

-- Declaração HAVING: recuperar categorias de produtos onde a média de avaliação seja maior ou igual a 4
SELECT category, AVG(avaliacao) AS avg_avaliacao
FROM product
GROUP BY category
HAVING AVG(avaliacao) >= 4.0;

-- Adicionar o campo "type" à tabela "cliente"
ALTER TABLE cliente
ADD type varchar(2) CHECK (type IN ('PJ', 'PF'));

-- Criar tabela payment_method 
CREATE TABLE payment_method (
    idPaymentMethod serial PRIMARY KEY,
    method_name varchar(30) NOT NULL
);

-- Criar tabela delivery_history
CREATE TABLE delivery_history (
    idDelivery serial PRIMARY KEY,
    idPedido int REFERENCES pedido(idPedido),
    delivery_status varchar(20),
    timestamp timestamp
);

-- Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
SELECT p.idPedido, c.Fname, c.Lname, po.poQuantity
FROM pedido p
JOIN cliente c ON p.idPedidoClient = c.idClient
JOIN productOrder po ON p.idPedido = po.idPOorder;

-- Modificar a tabela Pedido
ALTER TABLE pedido
ADD delivery_status varchar(20),
ADD tracking_code varchar(50);

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.idClient, c.Fname, c.Lname, COUNT(p.idPedido) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON c.idClient = p.idPedidoClient
GROUP BY c.idClient, c.Fname, c.Lname;

-- Algum vendedor também é fornecedor?
SELECT s.idSeller, s.abstName AS seller_name, e.socialName AS supplier_name
FROM seller s
JOIN entity e ON s.entity_id = e.entity_id;

-- Relação de produtos fornecedores e estoques
SELECT p.Pname, e.socialName AS supplier_name, ps.prodQuantity AS stock_quantity
FROM product p
JOIN productSeller ps ON p.idProduct = ps.idPproduct
JOIN seller s ON ps.idPseller = s.idSeller
JOIN entity e ON s.entity_id = e.entity_id;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT e.socialName AS supplier_name, p.Pname AS product_name
FROM supplier s
JOIN entity e ON s.entity_id = e.entity_id
JOIN product p ON s.idSupplier = p.idProduct;