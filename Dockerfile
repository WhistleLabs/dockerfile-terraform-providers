FROM alpine:3.6
MAINTAINER "WhistleLabs, Inc. <devops@whistle.com>"

# Loop through the list of providers that we want to include
RUN apk add --no-cache --update ca-certificates gnupg openssl git mercurial wget unzip && \
    gpg --keyserver keys.gnupg.net --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
    mkdir -p /usr/local/bin/terraform-providers && \
    for provider in \
    aws:0.1.4 \
    aws:1.10.0 \
    consul:0.1.0 \
    datadog:0.1.1 \
    github:0.1.1 \
    google:0.1.3 \
    heroku:0.1.0 \
    logentries:0.1.0 \
    newrelic:0.1.1 \
    pagerduty:0.1.2 \
    rabbitmq:0.2.0 \
    template:1.0.0; do \
        prov_name=`echo $provider | cut -d: -f1` && \
        prov_ver=`echo $provider | cut -d: -f2` && \
        echo "Installing provider ${prov_name} version ${prov_ver}" && \
        mkdir -p /tmp/build && \
        cd /tmp/build && \
        wget -q "https://releases.hashicorp.com/terraform-provider-${prov_name}/${prov_ver}/terraform-provider-${prov_name}_${prov_ver}_linux_amd64.zip" && \
        wget -q "https://releases.hashicorp.com/terraform-provider-${prov_name}/${prov_ver}/terraform-provider-${prov_name}_${prov_ver}_SHA256SUMS" && \
        wget -q "https://releases.hashicorp.com/terraform-provider-${prov_name}/${prov_ver}/terraform-provider-${prov_name}_${prov_ver}_SHA256SUMS.sig" && \
        gpg --batch --verify terraform-provider-${prov_name}_${prov_ver}_SHA256SUMS.sig terraform-provider-${prov_name}_${prov_ver}_SHA256SUMS && \
        grep terraform-provider-${prov_name}_${prov_ver}_linux_amd64.zip terraform-provider-${prov_name}_${prov_ver}_SHA256SUMS && \
        grep terraform-provider-${prov_name}_${prov_ver}_linux_amd64.zip terraform-provider-${prov_name}_${prov_ver}_SHA256SUMS | sha256sum -c && \
        unzip -d /usr/local/bin/terraform-providers terraform-provider-${prov_name}_${prov_ver}_linux_amd64.zip && \
        ls -l /usr/local/bin/terraform-providers && \
        cd /tmp && \
        rm -rf /tmp/build \
    ; done && \
    rm -rf /root/.gnupg
# Install 3rd party providers - eventually these should come from https://registry.terraform.io/
# See https://github.com/hashicorp/terraform/issues/17154
# and
# https://www.terraform.io/docs/configuration/providers.html#third-party-plugins
# and
# https://github.com/WhistleLabs/terraform-provider-cloudamqp
RUN mkdir -p /aws/.terraform.d/plugins && \
    for provider_url in \
    https://github.com/WhistleLabs/dockerfile-terraform-providers/files/1908683/terraform-provider-cloudamqp.zip; do \
        echo "Installing 3rd party provider from ${provider_url}" && \
        mkdir -p /tmp/build && \
        cd /tmp/build && \
        wget -q "${provider_url}" && \
        unzip -d /aws/.terraform.d/plugins terraform-provider-*.zip && \
        ls -l /aws/.terraform.d/plugins && \
        cd /tmp && \
        rm -rf /tmp/build \
    ; done
