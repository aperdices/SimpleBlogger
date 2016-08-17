-- (c) 2016 Antonio Perdices.
-- License: Public Domain.
-- You can use this code freely and wisely in your applications.

delete from REL_USER_ROLE;

delete from REL_ENTRY_TAG;

delete from ROLE;

delete from TAG;

delete from ENTRY;

delete from USER;

insert into USER (USERNAME, PASSWORD, NAME, LASTNAME, EMAIL, CREATION_DATE, MODIFICATION_DATE, ENABLED) values ('admin', 'd033e22ae348aeb5660fc2140aec35850c4da997', 'Antonio', 'Perdices', 'mail@mail.com', CURDATE(), CURDATE(), TRUE);

insert into ENTRY (USERNAME, TITLE, DESCRIPTION, BODY, CREATION_DATE, MODIFICATION_DATE, PUBLISHED) values ('admin', 'title1.', 'Description 1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent accumsan, diam tempor iaculis tempor, arcu lacus volutpat lectus, aliquam ullamcorper odio turpis auctor nulla. Quisque at erat. Mauris tortor sapien, pulvinar ut, adipiscing ut, iaculis vitae, mauris. Praesent ullamcorper urna sit amet dolor. Donec pharetra. Cras rutrum. Phasellus iaculis facilisis turpis. Curabitur bibendum. Maecenas quis turpis sed libero fermentum porta. Etiam eleifend. Sed suscipit adipiscing enim. Curabitur vel felis. Ut pretium ornare mauris. Suspendisse elit. Suspendisse mattis.', CURDATE(), CURDATE(), false);

insert into ENTRY (USERNAME, TITLE, DESCRIPTION, BODY, CREATION_DATE, MODIFICATION_DATE, PUBLISHED) values ('admin', 'title2.', 'Description 2', 'Aliquam erat volutpat. Quisque ante elit, euismod sed, ullamcorper eu, consequat eu, lacus. Aliquam erat volutpat. Aliquam dignissim. Phasellus ornare arcu sed quam condimentum malesuada. Nunc vitae nibh vel est imperdiet aliquam. Praesent ornare varius elit. Cras est eros, pulvinar eget, mattis vel, laoreet quis, lectus. Donec porttitor nibh. Ut volutpat, sapien in commodo blandit, odio enim suscipit tellus, et faucibus lacus lectus sed erat. Proin quis est quis enim ornare luctus. Praesent iaculis. Etiam gravida lacinia ligula. Aliquam erat volutpat. Sed aliquet libero vel mauris. Curabitur orci justo, mollis sit amet, iaculis eget, eleifend a, odio. Phasellus venenatis libero sed augue. Suspendisse eleifend, ante et elementum bibendum, lorem odio mollis nisi, id congue risus lorem fermentum purus.', CURDATE(), CURDATE(), false);

insert into ENTRY (USERNAME, TITLE, DESCRIPTION, BODY, CREATION_DATE, MODIFICATION_DATE, PUBLISHED) values ('admin', 'title3.', 'Description 3', 'Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec porttitor libero ac lectus ultrices tristique. Donec velit diam, feugiat vel, scelerisque vel, viverra vitae, urna. Pellentesque lacinia tortor ut purus. Nunc in nisl. Praesent quis orci eget mauris malesuada pharetra. Phasellus venenatis. Morbi mollis elementum dui. In hac habitasse platea dictumst. Aliquam tempor metus. Donec mollis nulla sit amet nulla. Pellentesque scelerisque dui vel odio. Suspendisse pretium varius nisl. In tristique tincidunt massa. Sed a neque eget lorem consequat hendrerit. Aliquam mattis varius eros. Ut sed metus et eros iaculis hendrerit.', CURDATE(), CURDATE(), false);

insert into ENTRY (USERNAME, TITLE, DESCRIPTION, BODY, CREATION_DATE, MODIFICATION_DATE, PUBLISHED) values ('admin', 'title4.', 'Description 4', 'Aliquam imperdiet augue vel nisi placerat sollicitudin. Donec lobortis. Pellentesque dapibus. Suspendisse mattis pulvinar neque. Praesent vel ante. Nullam nec tortor. Duis cursus auctor eros. Donec posuere arcu a dui. Duis facilisis ligula sit amet lacus. Suspendisse vulputate. Mauris eget orci sed dui facilisis venenatis.', CURDATE(), CURDATE(), false);

insert into ENTRY (USERNAME, TITLE, DESCRIPTION, BODY, CREATION_DATE, MODIFICATION_DATE, PUBLISHED) values ('admin', 'title5.', 'Description 5', 'Fusce elit nibh, rutrum eget, tristique a, faucibus a, purus. Donec dolor neque, tincidunt et, viverra non, vehicula ut, mauris. Quisque ut nisl. Morbi viverra cursus nisi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Phasellus euismod dolor nec metus posuere pretium. Morbi sagittis. Donec vestibulum aliquam turpis. Duis id lorem. Vivamus tellus. Vivamus gravida convallis nisi. Proin est purus, tincidunt ut, sollicitudin quis, interdum a, metus.', CURDATE(), CURDATE(), false);

insert into PAGE (USERNAME, TITLE, BODY, CREATION_DATE, MODIFICATION_DATE, MENU_ORDER, MENU_TITLE) values ('admin', 'title 1.', 'body 1.', CURDATE(), CURDATE(), 0, 'Title 1');

insert into PAGE (USERNAME, TITLE, BODY, CREATION_DATE, MODIFICATION_DATE, MENU_ORDER, MENU_TITLE) values ('admin', 'title 2.', 'body 2.', CURDATE(), CURDATE(), 1, 'Title 2');

insert into PAGE (USERNAME, TITLE, BODY, CREATION_DATE, MODIFICATION_DATE, MENU_ORDER, MENU_TITLE) values ('admin', 'title 3.', 'body 3.', CURDATE(), CURDATE(), 2, 'Title 3');

insert into PAGE (USERNAME, TITLE, BODY, CREATION_DATE, MODIFICATION_DATE, MENU_ORDER, MENU_TITLE) values ('admin', 'title 4.', 'body 4.', CURDATE(), CURDATE(), 3, 'Title 4');

insert into TAG (TAGNAME, CREATION_DATE, MODIFICATION_DATE) values ('tag1', CURDATE(), CURDATE());

insert into TAG (TAGNAME, CREATION_DATE, MODIFICATION_DATE) values ('tag2', CURDATE(), CURDATE());

insert into TAG (TAGNAME, CREATION_DATE, MODIFICATION_DATE) values ('tag3', CURDATE(), CURDATE());

insert into TAG (TAGNAME, CREATION_DATE, MODIFICATION_DATE) values ('tag4', CURDATE(), CURDATE());

insert into TAG (TAGNAME, CREATION_DATE, MODIFICATION_DATE) values ('tag5', CURDATE(), CURDATE());

insert into REL_ENTRY_TAG (TAG_ID, ENTRY_ID) values (1, 1);

insert into REL_ENTRY_TAG (TAG_ID, ENTRY_ID) values (2, 1);

insert into REL_ENTRY_TAG (TAG_ID, ENTRY_ID) values (3, 2);

insert into REL_ENTRY_TAG (TAG_ID, ENTRY_ID) values (4, 2);

insert into REL_ENTRY_TAG (TAG_ID, ENTRY_ID) values (1, 2);

insert into ROLE (ROLE, DESCRIPTION, CREATION_DATE, MODIFICATION_DATE) values ('ROLE_ADMIN', 'Administrator', CURDATE(), CURDATE());

insert into REL_USER_ROLE (USERNAME, ROLE) values ('admin', 'ROLE_ADMIN');

commit;