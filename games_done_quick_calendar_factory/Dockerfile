ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies
RUN apk add --no-cache \
    icu-libs \
    gcompat \
    curl \
    tar \
    gzip \
    libstdc++ \
    libgcc

# Set DOTNET_ROOT so that the dotnet CLI can find the runtime
ENV DOTNET_INSTALL_DIR /usr/share/dotnet
ENV PATH=$PATH:/usr/share/dotnet

# .NET 8 SDK and ASP.NET Core 8 runtimes for alpine
RUN  curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 8.0 --runtime dotnet \
    && /tmp/dotnet-install.sh --channel 8.0 --runtime aspnetcore

# Download and extract the latest release of GamesDoneQuickCalendarFactory
RUN mkdir -p /opt/gdq_calendar_factory \
    && curl -sSL https://github.com/Aldaviva/GamesDoneQuickCalendarFactory/releases/download/2.7.15/GamesDoneQuickCalendarFactory-linux-x64.zip -o /tmp/gdq_calendar_factory.zip \
    && unzip /tmp/gdq_calendar_factory.zip -d /opt/gdq_calendar_factory/ \
    && ls -al /opt/gdq_calendar_factory \
    && chmod a+x /opt/gdq_calendar_factory/gamesdonequickcalendarfactory \
    && rm /tmp/gdq_calendar_factory.zip

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
