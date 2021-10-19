variable "PLATFORMS" {
    default = [
        "linux/amd64",
        "linux/arm64",
    ]
}

group "default" {
    targets = [
        "php56",
        "php70",
        "php71",
        "php72",
        "php73",
        "php74",
        "php80",
    ]
}

group "php56" {
    targets = [
        "php56-fpm-stretch",
        "php56-fpm-stretch-console",
    ]
}

group "php70" {
    targets = [
        "php70-fpm-stretch",
        "php70-fpm-stretch-console",
    ]
}

group "php71" {
    targets = [
        "php71-fpm-stretch",
        "php71-fpm-stretch-console",
    ]
}

group "php72" {
    targets = [
        "php72-fpm-stretch",
        "php72-fpm-stretch-console",
    ]
}

group "php73" {
    targets = [
        "php73-fpm-stretch",
        "php73-fpm-stretch-console",
        "php73-fpm-buster",
        "php73-fpm-buster-console",
    ]
}

group "php74" {
    targets = [
        "php74-fpm-buster",
        "php74-fpm-buster-console",
    ]
}

group "php80" {
    targets = [
        "php80-fpm-buster",
        "php80-fpm-buster-console",
    ]
}

target "php56-fpm-stretch" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "5.6"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:5.6-fpm-stretch"
    ]
}

target "php56-fpm-stretch-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "5.6"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:5.6-fpm-stretch-console"
    ]
}

target "php70-fpm-stretch" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "7.0"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.0-fpm-stretch"
    ]
}

target "php70-fpm-stretch-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "7.0"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.0-fpm-stretch-console"
    ]
}

target "php71-fpm-stretch" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "7.1"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.1-fpm-stretch"
    ]
}

target "php71-fpm-stretch-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "7.1"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.1-fpm-stretch-console"
    ]
}

target "php72-fpm-stretch" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "7.2"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.2-fpm-stretch"
    ]
}

target "php72-fpm-stretch-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "7.2"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.2-fpm-stretch-console"
    ]
}

target "php73-fpm-stretch" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "7.4"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.3-fpm-stretch"
    ]
}

target "php73-fpm-stretch-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "7.3"
        BASEOS = "stretch"
        REDIS_VERSION = "5.0"
    }
    tags = [
        "my127/php:7.3-fpm-stretch-console"
    ]
}

target "php73-fpm-buster" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "7.3"
        BASEOS = "buster"
    }
    tags = [
        "my127/php:7.3-fpm-buster"
    ]
}

target "php73-fpm-buster-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "7.3"
        BASEOS = "buster"
    }
    tags = [
        "my127/php:7.3-fpm-buster-console"
    ]
}

target "php74-fpm-buster" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "7.4"
        BASEOS = "buster"
    }
    tags = [
        "my127/php:7.4-fpm-buster"
    ]
}

target "php74-fpm-buster-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "7.4"
        BASEOS = "buster"
    }
    tags = [
        "my127/php:7.4-fpm-buster-console"
    ]
}

target "php80-fpm-buster" {
    dockerfile = "Dockerfile"
    target = "base"
    platforms = PLATFORMS
    args = {
        VERSION = "8.0"
        BASEOS = "buster"
    }
    tags = [
        "my127/php:8.0-fpm-buster"
    ]
}

target "php80-fpm-buster-console" {
    dockerfile = "Dockerfile"
    target = "console"
    platforms = PLATFORMS
    args = {
        VERSION = "8.0"
        BASEOS = "buster"
    }
    tags = [
        "my127/php:8.0-fpm-buster-console"
    ]
}
