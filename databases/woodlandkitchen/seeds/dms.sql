INSERT INTO dms.module (name, parent_id) VALUES
  ('admin', null),
  ('group', 1),
  ('access', 1),
  ('menu', 1),
  ('account', 1);
UPDATE dms.module SET parent_id=3 WHERE id=2;

INSERT INTO dms.func (module_id, name) VALUES
  (2, 'main'),
  (2, 'create'),
  (2, 'edit'),
  (3, 'main'),
  (3, 'allowedfuncsbyaccessgroup'),
  (4, 'main'),
  (4, 'sub'),
  (4, 'create'),
  (4, 'edit'),
  (5, 'main'),
  (5, 'create'),
  (5, 'edit');

INSERT INTO dms.menu (name,parent_id,func_id,runmode,ordering) VALUES
  ('Admin', NULL, 1, 'run', 1),
  ('Access', 1, 1, 'run', 1),
  ('Access Groups', 2, 1, 'run', 1),
  ('Accounts', 2, 10, 'run', 2),
  ('Edit Access', 2, 4, 'popup', 3),
  ('Edit Menus', 1, 6, 'run', 2);

INSERT INTO dms.access_group (name) VALUES
  ('Default'),
  ('Administrators');

INSERT INTO dms.access_listing (access_group_id,func_id)
  (SELECT '2',id FROM dms.func);
