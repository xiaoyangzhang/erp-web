package com.yihg.erp.socket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.*;

import com.yimayhd.erpcenter.dal.sys.po.UserSession;

import java.io.IOException;
import java.util.ArrayList;

//@Service
public class SocketHandler implements WebSocketHandler {

    private static final Logger logger;
    private static final ArrayList<WebSocketSession> users;

    static {
        users = new ArrayList<WebSocketSession>();
        logger = LoggerFactory.getLogger(SocketHandler.class);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        users.add(session);
    }

    @Override
    public void handleMessage(WebSocketSession arg0, WebSocketMessage<?> arg1) throws Exception {
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable error) throws Exception {
        if (session.isOpen()) {
            session.close();
        }
        logger.error("连接出现错误:" + error.toString());
        users.remove(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus arg1) throws Exception {
        logger.debug("连接已关闭");
        users.remove(session);
    }

    @Override
    public boolean supportsPartialMessages() {
        return false;
    }

    /**
     * 给所有在线用户发送消息
     *
     * @param message
     */
    public void sendMessageToUsers(TextMessage message) {
        for (WebSocketSession user : users) {
            try {
                if (user.isOpen()) {
                    user.sendMessage(message);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 给某个用户发送消息
     *
     * @param userName
     * @param message
     */
    public void sendMessageToUser(Integer userId, TextMessage message) {
        for (WebSocketSession user : users) {
            UserSession us = (UserSession) user.getAttributes().get("userSession");
            if (us.getEmployeeId() == userId) {
                try {
                    if (user.isOpen()) {
                        user.sendMessage(message);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            }
        }
    }

}
