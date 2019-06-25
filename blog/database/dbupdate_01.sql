-- (c) 2019 Antonio Perdices.
-- License: Public Domain.
-- You can use this code freely and wisely in your applications.

ALTER TABLE PAGE ADD MENU_TITLE VARCHAR(128) AFTER MENU_ORDER;

COMMIT;