SELECT anon.stop_dynamic_masking();
SELECT anon.remove_masks_for_all_columns();
SELECT anon.remove_masks_for_all_roles();

REASSIGN OWNED BY tempo TO postgres;
DROP OWNED BY tempo;
DROP USER tempo;

DROP SCHEMA mask;

DROP SCHEMA stoma CASCADE;