package uk.co.gresearch.siembol.deployment.monitoring.application;

import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import uk.co.gresearch.siembol.common.metrics.SiembolMetricsRegistrar;
import uk.co.gresearch.siembol.common.metrics.spring.SpringMetricsRegistrar;
import uk.co.gresearch.siembol.deployment.monitoring.heartbeat.HeartbeatConsumer;
import uk.co.gresearch.siembol.deployment.monitoring.heartbeat.HeartbeatProducerScheduler;

@Configuration
@EnableConfigurationProperties(ServiceConfigurationProperties.class)
public class SiembolMonitoringConfiguration implements DisposableBean {
    @Autowired
    private ServiceConfigurationProperties properties;
    @Autowired
    private MeterRegistry springMeterRegistrar;
    private HeartbeatConsumer heartbeatConsumer;

    @Bean("metricsRegistrar")
    SiembolMetricsRegistrar metricsRegistrar() {
        return new SpringMetricsRegistrar(springMeterRegistrar);
    }

    @Bean("heartbeatProducerScheduler")
    @DependsOn("metricsRegistrar")
    HeartbeatProducerScheduler heartbeatProducerScheduler(@Autowired SiembolMetricsRegistrar metricsRegistrar) {
        return new HeartbeatProducerScheduler(properties.getHeartbeatProperties(), metricsRegistrar);
    }

    @Bean("heartbeatConsumer")
    @DependsOn("metricsRegistrar")
    HeartbeatConsumer heartbeatConsumer(@Autowired SiembolMetricsRegistrar metricsRegistrar) {
        heartbeatConsumer = new HeartbeatConsumer(properties.getHeartbeatProperties().getHeartbeatConsumer(), metricsRegistrar);
        return heartbeatConsumer;
    }

    @Override
    public void destroy() {
        if (heartbeatConsumer == null) {
            return;
        }
        heartbeatConsumer.close();
    }
}
