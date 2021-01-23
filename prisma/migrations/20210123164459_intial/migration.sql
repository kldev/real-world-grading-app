-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('STUDENT', 'TEACHER');

-- CreateEnum
CREATE TYPE "TokenType" AS ENUM ('EMAIL', 'API');

-- CreateTable
CREATE TABLE "dm_user" (
"id" SERIAL,
    "email" VARCHAR(255) NOT NULL,
    "first_name" VARCHAR(255),
    "last_name" VARCHAR(255),
    "social" JSONB,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dm_token" (
"id" SERIAL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" "TokenType" NOT NULL,
    "emailToken" TEXT,
    "valid" BOOLEAN NOT NULL DEFAULT true,
    "expiration" TIMESTAMP(3) NOT NULL,
    "userId" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dm_course" (
"id" SERIAL,
    "name" TEXT NOT NULL,
    "courseDetails" TEXT,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dm_course_enrollment" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "role" "UserRole" NOT NULL,
    "userId" INTEGER NOT NULL,
    "courseId" INTEGER NOT NULL,

    PRIMARY KEY ("userId","courseId")
);

-- CreateTable
CREATE TABLE "dm_test" (
"id" SERIAL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "courseId" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dm_test_result" (
"id" SERIAL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "result" INTEGER NOT NULL,
    "studentId" INTEGER NOT NULL,
    "graderId" INTEGER NOT NULL,
    "testId" INTEGER NOT NULL,

    PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dm_send_email" (
"id" SERIAL,
    "body" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "recipient" TEXT NOT NULL,
    "sentDate" TIMESTAMP(3),
    "wasSent" BOOLEAN NOT NULL DEFAULT false,

    PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "dm_user.email_unique" ON "dm_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "dm_token.emailToken_unique" ON "dm_token"("emailToken");

-- CreateIndex
CREATE INDEX "dm_course_enrollment.userId_role_index" ON "dm_course_enrollment"("userId", "role");

-- AddForeignKey
ALTER TABLE "dm_token" ADD FOREIGN KEY("userId")REFERENCES "dm_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dm_course_enrollment" ADD FOREIGN KEY("userId")REFERENCES "dm_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dm_course_enrollment" ADD FOREIGN KEY("courseId")REFERENCES "dm_course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dm_test" ADD FOREIGN KEY("courseId")REFERENCES "dm_course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dm_test_result" ADD FOREIGN KEY("studentId")REFERENCES "dm_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dm_test_result" ADD FOREIGN KEY("graderId")REFERENCES "dm_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dm_test_result" ADD FOREIGN KEY("testId")REFERENCES "dm_test"("id") ON DELETE CASCADE ON UPDATE CASCADE;
