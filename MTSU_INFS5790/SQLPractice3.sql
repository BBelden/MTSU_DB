-- User Alter Table commands to enforce the following constraints:

-- 1 --
-- Cus_Code is the PK in the CUSTOMER table.
SELECT * FROM customer;
ALTER TABLE customer ADD CONSTRAINT customer_cus_code_pk PRIMARY KEY (cus_code);

-- 2 --
-- Inv_Number is the PK in the INVOICE table.
ALTER TABLE invoice ADD CONSTRAINT invoice_inv_number_pk PRIMARY KEY (inv_number);

-- 3 --
-- Cus_Code is a FK in the ONVOICE table from the CUSTOMER table.
ALTER TABLE invoice ADD CONSTRAINT invoice_cus_code_fk FOREIGN KEY (cus_code) REFERENCES customer;

-- 4 --
-- V_Code is the PK in the VENDOR table.
ALTER TABLE vendor ADD CONSTRAINT vendor_v_code_pk PRIMARY KEY (v_code);

-- 5 --
-- P_Code is the PK in the PRODUCT table.
ALTER TABLE product ADD CONSTRAINT product_p_code_pk PRIMARY KEY (p_code);

-- 6 --
-- V_Code is a FK in the PRODUCT table from the VENDOR table.
ALTER TABLE product ADD CONSTRAINT product_v_code_fk FOREIGN KEY (v_code) REFERENCES vendor;

-- 7 --
-- Inv_Number and Line_Number are a composite PK in the LINE table.
ALTER TABLE line ADD CONSTRAINT line_inv_num_line_num_pk PRIMARY KEY (inv_number,line_number);

-- 8 --
-- Inv_Number is a FK in the LINE table from the INVOICE table.
ALTER TABLE line ADD CONSTRAINT line_inv_num_fk FOREIGN KEY (inv_number) REFERENCES invoice;

-- 9 --
-- P_Code is a FK in the LINE table from the PRODUCT table.
ALTER TABLE line ADD CONSTRAINT line_p_code_fk FOREIGN KEY (p_code) REFERENCES product;

