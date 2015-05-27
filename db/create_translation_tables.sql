CREATE TABLE locales (
    id integer,
    key character varying(255),
    interpolations text,
    is_proc boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locale character varying(255),
    value text,
    is_html boolean,
    complete boolean,
    is_list boolean
);

CREATE TABLE translation_keys (
    id integer,
    key character varying(255),
    interpolations text,
    is_proc boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    locale character varying(255),
    value text,
    is_html boolean,
    complete boolean,
    is_list boolean
);