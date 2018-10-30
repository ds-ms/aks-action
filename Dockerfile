FROM microsoft/azure-cli:2.0.47

LABEL version="1.0.0"

LABEL maintainer="Deepak Sattiraju"
LABEL com.github.actions.name="GitHub Action for Running Kubectl commands on AKS"
LABEL com.github.actions.description="Brings kubeconfig to the machine and runs kubectl commands"
LABEL com.github.actions.icon="triange"
LABEL com.github.actions.color="blue"
COPY LICENSE README.md THIRD_PARTY_NOTICE.md /

RUN az extension add --name aks \
  && apk update \
  && (apk info | xargs -n1 -I{} apk --quiet add {}-doc); true \
  && rm -rf /var/cache/apk/*
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/$k8sversion/bin/linux/amd64/kubectl
  && chmod +x ./kubectl
  && mv ./kubectl /usr/local/bin/kubectl

COPY --from=docker:stable /usr/local/bin/docker /usr/local/bin

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "help" ]
