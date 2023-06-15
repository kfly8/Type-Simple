requires 'perl', '5.0016003';

requires 'List::Util', '1.33';

on configure => sub {
    requires 'Devel::PPPort', '3.68';
    requires 'Module::Build::XSUtil', '0.19';
    requires 'XS::Parse::Keyword::Builder', '0.33';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
};

