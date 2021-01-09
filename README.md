
# Useful ROS2 commands
`ros2 param get /ServoManager use_mock_pca9685`

```bash
ros2 service call   /configure_pca9685                              \
                    servo_mgr/srv/ConfigurePCA9685                  \
                    '{id: 0, device_file: /dev/i2c-1, address: 0x40}'
```

```bash
ros2 service call   /configure_servo                                \
                    servo_mgr/srv/ConfigureServo                    \
                    '{id: 0, center: 2048, range: 4096}'
```

```bash
ros2 topic pub      --once                                          \
                    /servo_control_absolute                         \
                    servo_mgr/msg/ServoControl                      \
                    '{servo_id: 0, value: 42}'
```

```bash
ros2 topic pub      --once                                          \
                    /servo_control                                  \
                    servo_mgr/msg/ServoControl                      \
                    '{servo_id: 0, value: 0.0}'
```

# Useful linux tools:

apt-get install -y i2c-tools
i2cdetect -y 1

# Enable Raspberry Pi camera
Since we're using balenaOS (vice Raspbian), enabling the camera requires custom steps via the Balena control panel:
1. Within the application (ros-donkey), navigate to Fleet Variables
2. Add the following:
     * BALENA_HOST_CONFIG_start_x=1
     * BALENA_HOST_CONFIG_gpu_mem=128
3. Within the Dockerfile, add the following:
     `RUN echo bcm2835-v4l2 >> /etc/modules`

Reference: https://www.balena.io/docs/learn/develop/hardware/i2c-and-spi/#raspberry-pi-family

# Enable Raspberry Pi I2C
Similar to enabling the camera, in the Dockerfile, add the following:
    `RUN echo i2-dev >> /etc/modules`
