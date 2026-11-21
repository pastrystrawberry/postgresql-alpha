CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP,
  "name" "VARCHAR(100)",
  "email" "VARCHAR(150)" UNIQUE,
  "phone" "VARCHAR(15)" UNIQUE,
  "password" "VARCHAR(255)"
);

CREATE TABLE "addresses" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER,
  "address_line" TEXT,
  "city" "VARCHAR(100)",
  "state" "VARCHAR(100)",
  "pincode" "VARCHAR(10)",
  "latitude" "DECIMAL(10,7)",
  "longitude" "DECIMAL(10,7)",
  "created_at" TIMESTAMP
);

CREATE TABLE "restaurants" (
  "id" SERIAL PRIMARY KEY,
  "name" "VARCHAR(150)",
  "description" TEXT,
  "address" TEXT,
  "city" "VARCHAR(100)",
  "phone" "VARCHAR(15)",
  "rating" "DECIMAL(2,1)",
  "is_open" BOOLEAN,
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

CREATE TABLE "restaurant_owners" (
  "id" SERIAL PRIMARY KEY,
  "restaurant_id" INTEGER,
  "name" "VARCHAR(100)",
  "email" "VARCHAR(150)" UNIQUE,
  "password" "VARCHAR(255)"
);

CREATE TABLE "categories" (
  "id" SERIAL PRIMARY KEY,
  "name" "VARCHAR(100)" UNIQUE
);

CREATE TABLE "menu_items" (
  "id" SERIAL PRIMARY KEY,
  "restaurant_id" INTEGER,
  "category_id" INTEGER,
  "name" "VARCHAR(150)",
  "description" TEXT,
  "price" "DECIMAL(10,2)",
  "is_vegetarian" BOOLEAN,
  "is_available" BOOLEAN,
  "created_at" TIMESTAMP
);

CREATE TABLE "carts" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER,
  "restaurant_id" INTEGER,
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

CREATE TABLE "cart_items" (
  "id" SERIAL PRIMARY KEY,
  "cart_id" INTEGER,
  "item_id" INTEGER,
  "quantity" INTEGER
);

CREATE TABLE "delivery_partners" (
  "id" SERIAL PRIMARY KEY,
  "name" "VARCHAR(100)",
  "phone" "VARCHAR(15)" UNIQUE,
  "vehicle_number" "VARCHAR(20)",
  "is_available" BOOLEAN,
  "created_at" TIMESTAMP
);

CREATE TABLE "orders" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER,
  "restaurant_id" INTEGER,
  "address_id" INTEGER,
  "partner_id" INTEGER,
  "order_status" "VARCHAR(30)",
  "total_amount" "DECIMAL(10,2)",
  "delivery_fee" "DECIMAL(10,2)",
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

CREATE TABLE "order_items" (
  "id" SERIAL PRIMARY KEY,
  "order_id" INTEGER,
  "item_id" INTEGER,
  "quantity" INTEGER,
  "item_price" "DECIMAL(10,2)",
  "subtotal" "DECIMAL(10,2)"
);

CREATE TABLE "payments" (
  "id" SERIAL PRIMARY KEY,
  "order_id" INTEGER UNIQUE,
  "payment_method" "VARCHAR(30)",
  "payment_status" "VARCHAR(30)",
  "amount" "DECIMAL(10,2)",
  "transaction_id" "VARCHAR(150)" UNIQUE,
  "paid_at" TIMESTAMP,
  "created_at" TIMESTAMP
);

CREATE TABLE "reviews" (
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER,
  "restaurant_id" INTEGER,
  "order_id" INTEGER UNIQUE,
  "rating" INTEGER,
  "comment" TEXT,
  "created_at" TIMESTAMP
);

CREATE TABLE "coupons" (
  "id" SERIAL PRIMARY KEY,
  "code" "VARCHAR(30)" UNIQUE,
  "discount_percentage" "DECIMAL(5,2)",
  "max_discount" "DECIMAL(10,2)",
  "min_order_amount" "DECIMAL(10,2)",
  "expiry_date" TIMESTAMP,
  "is_active" BOOLEAN
);

CREATE TABLE "order_status_history" (
  "id" SERIAL PRIMARY KEY,
  "order_id" INTEGER,
  "status" "VARCHAR(30)",
  "changed_at" TIMESTAMP
);

ALTER TABLE "addresses" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "restaurant_owners" ADD FOREIGN KEY ("restaurant_id") REFERENCES "restaurants" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "menu_items" ADD FOREIGN KEY ("restaurant_id") REFERENCES "restaurants" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "menu_items" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "carts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "carts" ADD FOREIGN KEY ("restaurant_id") REFERENCES "restaurants" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "cart_items" ADD FOREIGN KEY ("cart_id") REFERENCES "carts" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "cart_items" ADD FOREIGN KEY ("item_id") REFERENCES "menu_items" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("restaurant_id") REFERENCES "restaurants" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("address_id") REFERENCES "addresses" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("partner_id") REFERENCES "delivery_partners" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "order_items" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "order_items" ADD FOREIGN KEY ("item_id") REFERENCES "menu_items" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("id") REFERENCES "payments" ("order_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reviews" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "reviews" ADD FOREIGN KEY ("restaurant_id") REFERENCES "restaurants" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "orders" ADD FOREIGN KEY ("id") REFERENCES "reviews" ("order_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "order_status_history" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("id") DEFERRABLE INITIALLY IMMEDIATE;
