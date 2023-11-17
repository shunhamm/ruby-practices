```mermaid
classDiagram
    class Path {
        -String path
        +Array~String~ files()
        +FileMetaData get_file_metadata(String filename)
    }

    class FileMetaData {
        -String name
        -DateTime lastModified
        -Integer size
        +String permissions
        +String owner
        +String group
    }

    class LsOption {
        -Hash options
        +void parse_options(Array~String~ args)
        +boolean is_option_set(String option)
    }

    class LsCommand {
        -LsOption options
        -Array~Path~ paths
        +void show_ls()
        -Array~String~ build_ls()
        -Array~String~ sort_files(Array~String~ files)
        -Array~String~ filter_files(Array~String~ files)
        -String format_file_list(Array~String~ files)
    }

    Path "1" -- "1" LsCommand: uses
    FileMetaData "1" -- "*" Path: has
    LsOption "1" -- "1" LsCommand: uses
