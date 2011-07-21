package org.ow2.proactive.scheduler.ext.matlab.common.exception;

/**
 * UnreachableLicenseProxyException
 *
 * @author The ProActive Team
 */
public class UnreachableLicenseProxyException extends Exception {

    /**  */
    private static final long serialVersionUID = 31L;

    public UnreachableLicenseProxyException(String message) {
        super(message);
    }

    public UnreachableLicenseProxyException(Throwable cause) {
        super(cause);
    }

    public UnreachableLicenseProxyException(String message, Throwable cause) {
        super(message, cause);
    }
}